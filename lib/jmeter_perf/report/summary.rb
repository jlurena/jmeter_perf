require "csv"
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

        @file_path = file_path
      end

      # Marks the summary as finished, allowing any pending asynchronous operations to complete.
      #
      # @return [void]
      def finish!
        @finished = true
      end

      # Starts streaming and processing JTL file content asynchronously.
      #
      # @return [Thread] a thread that handles the asynchronous file streaming and parsing
      def stream_jtl_async
        Thread.new do
          sleep 0.1 until File.exist?(@file_path) # Wait for the file to be created

          File.open(@file_path, "r") do |file|
            file.seek(0, IO::SEEK_END)
            until file.eof? && @finished
              line = file.gets
              if line
                parse_csv_row(line)
              else
                sleep 0.1 # Small delay to avoid busy waiting
              end
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
        @requests_per_minute = @total_elapsed_time.zero? ? 0 : @total_requests / (@total_elapsed_time / 1000)
        @standard_deviation = @running_statistics_helper.std
      end

      private

      # Parses a single CSV row from the JTL file and updates running statistics.
      #
      # @param csv_row [String] a single line from the CSV-formatted JTL file
      # @return [void]
      def parse_csv_row(csv_row)
        CSV.parse(csv_row, headers: JTL_HEADER).each do |row|
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
