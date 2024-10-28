require "tdigest"

module JmeterPerf::Helpers
  # Provides running statistics for a series of numbers, including approximate percentiles and
  # standard deviation.
  #
  # @note This class uses a TDigest data structure to keep statistics "close enough". Accuracy is not guaranteed.
  class RunningStatistisc
    # The marker for when to call the compression function on the TDigest structure.
    COMPRESS_MARKER = 1000

    # @return [Float] the running average of the numbers added
    attr_reader :avg

    # Initializes a new instance of RunningStatistisc to calculate running statistics.
    #
    # @return [RunningStatistisc]
    def initialize
      @tdigest = ::TDigest::TDigest.new
      @count = 0
      @avg = 0
      @m2 = 0 # Sum of squares of differences from the avg
    end

    # Adds a number to the running statistics and updates the average and variance calculations.
    #
    # @param num [Float] the number to add to the running statistics
    # @return [void]
    def add_number(num)
      @tdigest.push(num)

      @count += 1
      delta = num - @avg
      @avg += delta / @count
      delta2 = num - @avg
      @m2 += delta * delta2

      # Compress data every 1000 items to maintain memory efficiency
      @tdigest.compress! if @count % COMPRESS_MARKER == 0
    end

    # Retrieves approximate percentiles for the data set based on the requested percentile values.
    #
    # @param percentiles [Array<Float>] the requested percentiles (e.g., 0.5 for the 50th percentile)
    # @return [Array<Float>] an array of calculated percentiles corresponding to the requested values
    # @example Requesting the 10th, 50th, and 95th percentiles
    #   get_percentiles(0.1, 0.5, 0.95) #=> [some_value_for_10th, some_value_for_50th, some_value_for_95th]
    def get_percentiles(*percentiles)
      @tdigest.compress!
      percentiles.map { |percentile| @tdigest.percentile(percentile) }
    end

    # Calculates the standard deviation of the numbers added so far.
    #
    # @return [Float] the standard deviation, or 0 if fewer than two values have been added
    def standard_deviation
      return 0 if @count < 2
      Math.sqrt(@m2 / (@count - 1))
    end
    alias_method :std, :standard_deviation
  end
end
