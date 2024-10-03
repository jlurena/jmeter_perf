require "tdigest"
module JmeterPerf
  # NOTE: These statistics are NOT 100% accurate, but rather "close enough"
  class RunningStatistisc
    COMPRESS_MARKER = 1000 # When to call compress
    attr_reader :avg

    def initialize
      @tdigest = ::TDigest::TDigest.new
      @count = 0
      @avg = 0
      @m2 = 0 # Sum of squares of differences from the avg
    end

    def add_number(num)
      @tdigest.push(num)

      @count += 1
      delta = num - @avg
      @avg += delta / @count
      delta2 = num - @avg
      @m2 += delta * delta2

      # Compress data every 1000 items
      if @count % COMPRESS_MARKER == 0
        @tdigest.compress!
      end
    end

    def get_percentiles(*percentiles)
      @tdigest.compress!
      percentiles.map { |percentile| @tdigest.percentile(percentile) }
    end

    def standard_deviation
      return 0 if @count < 2
      Math.sqrt(@m2 / (@count - 1))
    end
    alias_method :std, :standard_deviation
  end
end
