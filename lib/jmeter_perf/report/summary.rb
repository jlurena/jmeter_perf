require "csv"
require_relative "../helpers/running_statistics"

module JmeterPerf::Report
  class Summary
    attr_reader :name,
      :avg,
      :error_percentage,
      :max,
      :min,
      :p10,
      :p50,
      :p95,
      :requests_per_minute,
      :response_codes,
      :standard_deviation,
      :total_bytes,
      :total_elapsed_time,
      :total_errors,
      :total_latency,
      :total_requests,
      :total_sent_bytes

    alias_method :rpm, :requests_per_minute
    alias_method :std, :standard_deviation
    alias_method :median, :p50

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

    def initialize(file_path, name = nil)
      @name = name || file_path.to_s.tr("/", "_")
      @finished = false
      @running_statistics_helper = JmeterPerf::RunningStatistisc.new

      @max = 0
      @min = 1000000
      @response_codes = Hash.new { |h, k| h[k.to_s] = 0 }
      @total_bytes = 0
      @total_elapsed_time = 0
      @total_errors = 0
      @total_latency = 0
      @total_requests = 0
      @total_sent_bytes = 0

      @file_path = file_path
    end

    def finish!
      @finished = true
    end

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

    def summarize_data!
      @p10, @p50, @p95 = @running_statistics_helper.get_percentiles(0.1, 0.5, 0.95)
      @error_percentage = (@total_errors.to_f / @total_requests) * 100
      @avg = @running_statistics_helper.avg
      @requests_per_minute = @total_elapsed_time.zero? ? 0 : @total_requests / (@total_elapsed_time / 1000)
      @standard_deviation = @running_statistics_helper.std
    end

    private

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
