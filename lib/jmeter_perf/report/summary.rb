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
    #

    # @!attribute [rw] avg
    #   @return [Float] the average response time
    # @!attribute [rw] error_percentage
    #   @return [Float] the error percentage across all requests
    # @!attribute [rw] max
    #   @return [Integer] the maximum response time encountered
    # @!attribute [rw] min
    #   @return [Integer] the minimum response time encountered
    # @!attribute [rw] p10
    #   @return [Float] the 10th percentile of response times
    # @!attribute [rw] p50
    #   @return [Float] the median (50th percentile) of response times
    # @!attribute [rw] p95
    #   @return [Float] the 95th percentile of response times
    # @!attribute [rw] requests_per_minute
    #   @return [Float] the requests per minute rate
    # @!attribute [rw] response_codes
    #   @return [Hash<String, Integer>] a hash of response codes with their respective counts
    # @!attribute [rw] standard_deviation
    #   @return [Float] the standard deviation of response times
    # @!attribute [rw] total_bytes
    #   @return [Integer] the total number of bytes received
    # @!attribute [rw] total_errors
    #   @return [Integer] the total number of errors encountered
    # @!attribute [rw] total_latency
    #   @return [Integer] the total latency time across all requests
    # @!attribute [rw] total_requests
    #   @return [Integer] the total number of requests processed
    # @!attribute [rw] total_sent_bytes
    #   @return [Integer] the total number of bytes sent
    # @!attribute [rw] csv_error_lines
    #   @return [Array<Integer>] the line numbers of where CSV errors were encountered
    # @!attribute [rw] total_run_time
    #   @return [Integer] the total run time in seconds
    # @!attribute [rw] name
    #   @return [String] the name of the summary, derived from the file path if not provided
    # @!attribute [rw] response_codes
    #   @return [Hash<String, Integer>] a hash of response codes with their respective counts
    # @!attribute [rw] csv_error_lines
    #   @return [Array<Integer>] the line numbers of where CSV errors were encountered
    class Summary
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

      # @return [Hash<String, Symbol>] a mapping of CSV headers to their corresponding attribute symbols.
      CSV_HEADER_MAPPINGS = {
        "Name" => :name,
        "Average Response Time" => :avg,
        "Error Percentage" => :error_percentage,
        "Max Response Time" => :max,
        "Min Response Time" => :min,
        "10th Percentile" => :p10,
        "Median (50th Percentile)" => :p50,
        "95th Percentile" => :p95,
        "Requests Per Minute" => :requests_per_minute,
        "Standard Deviation" => :standard_deviation,
        "Total Run Time" => :total_run_time,
        "Total Bytes" => :total_bytes,
        "Total Errors" => :total_errors,
        "Total Latency" => :total_latency,
        "Total Requests" => :total_requests,
        "Total Sent Bytes" => :total_sent_bytes
        # "Response Code 200" => :response_codes["200"],
        # "Response Code 500" => :response_codes["500"] etc.
      }

      attr_accessor(*CSV_HEADER_MAPPINGS.values)
      # Response codes have multiple keys, so we need to handle them separately
      attr_accessor :response_codes
      # CSV Error Lines are an array of integers that get delimited by ":" when written to the CSV
      attr_accessor :csv_error_lines
      alias_method :rpm, :requests_per_minute
      alias_method :std, :standard_deviation
      alias_method :median, :p50

      # Reads a generated CSV report and sets all appropriate attributes.
      #
      # @param csv_path [String] the file path of the CSV report to read
      # @return [Summary] a new Summary instance with the parsed data
      def self.read(csv_path)
        summary = new(file_path: csv_path)
        CSV.foreach(csv_path, headers: true) do |row|
          metric = row["Metric"]
          value = row["Value"]

          if metric == "Name"
            summary.name = value
          elsif metric.start_with?("Response Code")
            code = metric.split.last
            summary.response_codes[code] = value.to_i
          elsif metric == "CSV Errors"
            summary.csv_error_lines = value.split(":").map(&:to_i)
          elsif CSV_HEADER_MAPPINGS.key?(metric)
            summary.public_send(:"#{CSV_HEADER_MAPPINGS[metric]}=", value.include?(".") ? value.to_f : value.to_i)
          end
        end
        summary
      end

      # Initializes a new Summary instance for analyzing performance data.
      #
      # @param file_path [String] the file path of the performance file to summarize. Either a JTL or CSV file.
      # @param name [String, nil] an optional name for the summary, derived from the file path if not provided (default: nil)
      # @param jtl_read_timeout [Integer] the maximum number of seconds to wait for a line read (default: 3)
      def initialize(file_path:, name: nil, jtl_read_timeout: 30)
        @name = name || file_path.to_s.tr("/", "_")
        @jtl_read_timeout = jtl_read_timeout
        @finished = false
        @running_statistics_helper = JmeterPerf::Helpers::RunningStatistisc.new

        @max = 0
        @min = 1_000_000
        @response_codes = Hash.new { |h, k| h[k.to_s] = 0 }
        @total_bytes = 0
        @total_errors = 0
        @total_latency = 0
        @total_requests = 0
        @total_sent_bytes = 0
        @csv_error_lines = []

        @file_path = file_path

        @start_time = nil
        @end_time = nil
      end

      # Marks the summary as finished and joins the processing thread.
      #
      # @return [void]
      def finish!
        @finished = true
        @processing_jtl_thread&.join
      end

      # Generates a CSV report with the given output file.
      #
      # The CSV report includes the following:
      # - A header row with "Metric" and "Value".
      # - Rows for each metric and its corresponding value from `CSV_HEADER_MAPPINGS`.
      # - Rows for each response code and its count from `@response_codes`.
      # - A row for CSV errors, concatenated with ":".
      #
      # @param output_file [String] The path to the output CSV file.
      # @return [void]
      def write_csv(output_file)
        CSV.open(output_file, "wb") do |csv|
          csv << ["Metric", "Value"]
          CSV_HEADER_MAPPINGS.each do |metric, value|
            csv << [metric, public_send(value)]
          end
          @response_codes.each do |code, count|
            csv << ["Response Code #{code}", count]
          end

          csv << ["CSV Errors", @csv_error_lines.join(":")]
        end
      end

      # Starts streaming and processing JTL file content asynchronously.
      # @note Once streaming, in order to finish processing, call `finish!` otherwise it will continue indefinitely.
      # @return [void]
      def stream_jtl_async
        @processing_jtl_thread = Thread.new do
          Timeout.timeout(@jtl_read_timeout, nil, "Timed out attempting to open JTL File #{@file_path}") do
            sleep 0.1 until File.exist?(@file_path) # Wait for the file to be created
          end

          File.open(@file_path, "r") do |file|
            until @finished && file.eof?
              line = file.gets

              # Skip if the line is nil. This can happen if not @finished, and we are at EOF
              next if line.nil?
              # Process only if the line is complete. JMeter always finishes with a newline
              read_until_complete_line(file, line)
            end
          end
        end

        @processing_jtl_thread.abort_on_exception = true
        nil
      end

      # Summarizes the collected data by calculating statistical metrics and error rates.
      #
      # @return [void]
      def summarize_data!
        @p10, @p50, @p95 = @running_statistics_helper.get_percentiles(0.1, 0.5, 0.95)
        @error_percentage = (@total_errors.to_f / @total_requests) * 100
        @avg = @running_statistics_helper.avg
        @total_run_time = ((@end_time - @start_time) / 1000).to_f  # Convert milliseconds to seconds
        @requests_per_minute = @total_run_time.zero? ? 0 : (@total_requests / @total_run_time) * 60.0
        @standard_deviation = @running_statistics_helper.std
      end

      private

      def read_until_complete_line(file, line)
        lineno = file.lineno
        return if lineno == 1 # Skip the header row
        Timeout.timeout(@jtl_read_timeout, nil, "Timed out processing line #{lineno}") do
          # If finished and eof but no newline: Means processing was interrupted
          # JMeter always finishes with a new line in the JTL file
          until line.end_with?("\n") || (file.eof? && @finished)
            sleep 0.1
            line += file.gets
          end
        end
        parse_csv_row(line)
      rescue Timeout::Error
        raise Timeout::Error, "Timed out reading JTL file at line #{lineno}"
      rescue CSV::MalformedCSVError
        @csv_error_lines << file.lineno
      end

      def parse_csv_row(line)
        CSV.parse(line, headers: JTL_HEADER, liberal_parsing: true).each do |row|
          line_item = row.to_hash
          elapsed = line_item.fetch(:elapsed).to_i
          timestamp = line_item.fetch(:timeStamp).to_i

          # Update start and end times
          @start_time = timestamp if @start_time.nil? || timestamp < @start_time
          @end_time = timestamp + elapsed if @end_time.nil? || (timestamp + elapsed) > @end_time

          # Continue with processing the row as before...
          @running_statistics_helper.add_number(elapsed)
          @total_requests += 1
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
