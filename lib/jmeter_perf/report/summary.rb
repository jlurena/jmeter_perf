require "csv"
require "timeout"
require_relative "../helpers/running_statistics"

module JmeterPerf
  module Report
    # Summary provides a statistical analysis of performance test results by processing
    # JMeter JTL files. It calculates metrics such as average response time, error percentage,
    # min/max response times, and percentiles, helping to understand the distribution of
    # response times across requests.
    # @note This class uses a TDigest data structure to keep statistics "close enough". Accuracy is not guaranteed.
    class Summary
      # @return [String] the name of the summary, usually derived from the file path
      attr_reader :name
      # @return [Float] the average response time
      attr_reader :avg
      # @return [Float] the error percentage across all requests
      attr_reader :error_percentage
      # @return [Integer] the maximum response time encountered
      attr_reader :max
      # @return [Integer] the minimum response time encountered
      attr_reader :min
      # @return [Float] the 10th percentile of response times
      attr_reader :p10
      # @return [Float] the median (50th percentile) of response times
      attr_reader :p50
      # @return [Float] the 95th percentile of response times
      attr_reader :p95
      # @return [Float] the requests per minute rate
      attr_reader :requests_per_minute
      # @return [Hash<String, Integer>] a hash of response codes with their respective counts
      attr_reader :response_codes
      # @return [Float] the standard deviation of response times
      attr_reader :standard_deviation
      # @return [Integer] the total number of bytes received
      attr_reader :total_bytes
      # @return [Integer] the total elapsed time in milliseconds
      attr_reader :total_elapsed_time
      # @return [Integer] the total number of errors encountered
      attr_reader :total_errors
      # @return [Integer] the total latency time across all requests
      attr_reader :total_latency
      # @return [Integer] the total number of requests processed
      attr_reader :total_requests
      # @return [Integer] the total number of bytes sent
      attr_reader :total_sent_bytes
      # @return [Array<Integer>] the line numbers of where CSV errors were encountered
      attr_reader :csv_error_lines

      alias_method :rpm, :requests_per_minute
      alias_method :std, :standard_deviation
      alias_method :median, :p50

      # JTL file headers used for parsing CSV rows
      JTL_HEADER = %i[
        timeStamp
        elapsed
        label
        responseCode
        responseMessage
        threadName
        dataType
        success
        failureMessage
        bytes
        sentBytes
        grpThreads
        allThreads
        URL
        Latency
        IdleTime
        Connect
      ]

      CSV_HEADER_MAPPINGS = {
        "Average Response Time" => :@avg,
        "Error Percentage" => :@error_percentage,
        "Max Response Time" => :@max,
        "Min Response Time" => :@min,
        "10th Percentile" => :@p10,
        "Median (50th Percentile)" => :@p50,
        "95th Percentile" => :@p95,
        "Requests Per Minute" => :@requests_per_minute,
        "Standard Deviation" => :@standard_deviation,
        "Total Bytes" => :@total_bytes,
        "Total Elapsed Time" => :@total_elapsed_time,
        "Total Errors" => :@total_errors,
        "Total Latency" => :@total_latency,
        "Total Requests" => :@total_requests,
        "Total Sent Bytes" => :@total_sent_bytes
      }

      # Initializes a new Summary instance for analyzing performance data.
      #
      # @param file_path [String] the file path of the JTL file to analyze
      # @param name [String, nil] an optional name for the summary, derived from the file path if not provided (default: nil)
      def initialize(file_path, name = nil)
        @name = name || file_path.to_s.tr("/", "_")
        @finished = false
        @running_statistics_helper = JmeterPerf::Helpers::RunningStatistisc.new

        @max = 0
        @min = 1_000_000
        @response_codes = Hash.new { |h, k| h[k.to_s] = 0 }
        @total_bytes = 0
        @total_elapsed_time = 0
        @total_errors = 0
        @total_latency = 0
        @total_requests = 0
        @total_sent_bytes = 0
        @csv_error_lines = []

        @file_path = file_path
      end

      # Marks the summary as finished, allowing any pending asynchronous operations to complete.
      #
      # @return [void]
      def finish!
        @finished = true
        @processing_jtl_thread.join if @processing_jtl_thread&.alive?
      end

      # Reads the generated CSV report and sets all appropriate attributes.
      #
      # @param csv_file [String] the file path of the CSV report to read
      # @return [void]
      def read_csv_report(csv_file)
        CSV.foreach(csv_file, headers: true) do |row|
          metric = row["Metric"]
          value = row["Value"]

          if CSV_HEADER_MAPPINGS.key?(metric)
            instance_variable_set(CSV_HEADER_MAPPINGS[metric], value.to_f)
          elsif metric.start_with?("Response Code")
            code = metric.split.last
            @response_codes[code] = value.to_i
          elsif metric == "CSV Errors"
            @csv_error_lines = value.split(":")
          end
        end
      end

      def generate_csv_report(output_file)
        CSV.open(output_file, "wb") do |csv|
          csv << ["Metric", "Value"]
          CSV_HEADER_MAPPINGS.each do |metric, value|
            csv << [metric, instance_variable_get(value)]
          end
          @response_codes.each do |code, count|
            csv << ["Response Code #{code}", count]
          end

          csv << ["CSV Errors", @csv_error_lines.join(":")]
        end
      end

      # Starts streaming and processing JTL file content asynchronously.
      #
      # @return [Thread] a thread that handles the asynchronous file streaming and parsing
      def stream_jtl_async
        @processing_jtl_thread = Thread.new do
          sleep 0.1 until File.exist?(@file_path) # Wait for the file to be created

          File.open(@file_path, "r") do |file|
            file.seek(0, IO::SEEK_END)
            until @finished && file.eof?
              line = file.gets
              next unless line # Skip if no line was read

              # Process only if the line is complete (ends with a newline)
              read_until_complete_line(file, line)
            end
          end
        end
      end

      # Summarizes the collected data by calculating statistical metrics and error rates.
      #
      # @return [void]
      def summarize_data!
        @p10, @p50, @p95 = @running_statistics_helper.get_percentiles(0.1, 0.5, 0.95)
        @error_percentage = (@total_errors.to_f / @total_requests) * 100
        @avg = @running_statistics_helper.avg
        @requests_per_minute = @total_elapsed_time.zero? ? 0 : (@total_requests / (@total_elapsed_time / 1000)) * 60
        @standard_deviation = @running_statistics_helper.std
      end

      private

      def read_until_complete_line(file, line, max_wait_seconds = 5)
        return if file.lineno == 1 # Skip the header row
        Timeout.timeout(max_wait_seconds) do
          until line.end_with?("\n")
            sleep 0.1
            line += file.gets.to_s
          end
        end
        parse_csv_row(line)
      rescue Timeout::Error
        puts "Timeout waiting for line to complete: #{line}"
        raise
      rescue CSV::MalformedCSVError
        @csv_error_lines << file.lineno
      end

      def parse_csv_row(line)
        CSV.parse(line, headers: JTL_HEADER, liberal_parsing: true).each do |row|
          line_item = row.to_hash
          elapsed = line_item.fetch(:elapsed).to_i

          @running_statistics_helper.add_number(elapsed)
          @total_requests += 1
          @total_elapsed_time += elapsed
          @response_codes[line_item.fetch(:responseCode)] += 1
          @total_errors += (line_item.fetch(:success) == "true") ? 0 : 1
          @total_bytes += line_item.fetch(:bytes, 0).to_i
          @total_sent_bytes += line_item.fetch(:sentBytes, 0).to_i
          @total_latency += line_item.fetch(:Latency).to_i
          @min = [@min, elapsed].min
          @max = [@max, elapsed].max
        end
      end
    end
  end
end
