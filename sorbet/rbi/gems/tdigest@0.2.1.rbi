# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `tdigest` gem.
# Please instead update this file by running `bin/tapioca gem tdigest`.


# source://tdigest//lib/tdigest.rb#3
module TDigest; end

# source://tdigest//lib/tdigest/centroid.rb#4
class TDigest::Centroid
  # @return [Centroid] a new instance of Centroid
  #
  # source://tdigest//lib/tdigest/centroid.rb#6
  def initialize(mean, n, cumn, mean_cumn = T.unsafe(nil)); end

  # source://tdigest//lib/tdigest/centroid.rb#13
  def as_json(_ = T.unsafe(nil)); end

  # Returns the value of attribute cumn.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def cumn; end

  # Sets the attribute cumn
  #
  # @param value the value to set the attribute cumn to.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def cumn=(_arg0); end

  # Returns the value of attribute mean.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def mean; end

  # Sets the attribute mean
  #
  # @param value the value to set the attribute mean to.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def mean=(_arg0); end

  # Returns the value of attribute mean_cumn.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def mean_cumn; end

  # Sets the attribute mean_cumn
  #
  # @param value the value to set the attribute mean_cumn to.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def mean_cumn=(_arg0); end

  # Returns the value of attribute n.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def n; end

  # Sets the attribute n
  #
  # @param value the value to set the attribute n to.
  #
  # source://tdigest//lib/tdigest/centroid.rb#5
  def n=(_arg0); end
end

# source://tdigest//lib/tdigest/tdigest.rb#7
class TDigest::TDigest
  # @return [TDigest] a new instance of TDigest
  #
  # source://tdigest//lib/tdigest/tdigest.rb#12
  def initialize(delta = T.unsafe(nil), k = T.unsafe(nil), cx = T.unsafe(nil)); end

  # source://tdigest//lib/tdigest/tdigest.rb#22
  def +(other); end

  # source://tdigest//lib/tdigest/tdigest.rb#30
  def as_bytes; end

  # source://tdigest//lib/tdigest/tdigest.rb#67
  def as_json(_ = T.unsafe(nil)); end

  # source://tdigest//lib/tdigest/tdigest.rb#39
  def as_small_bytes; end

  # source://tdigest//lib/tdigest/tdigest.rb#71
  def bound_mean(x); end

  # source://tdigest//lib/tdigest/tdigest.rb#77
  def bound_mean_cumn(cumn); end

  # Returns the value of attribute centroids.
  #
  # source://tdigest//lib/tdigest/tdigest.rb#11
  def centroids; end

  # Sets the attribute centroids
  #
  # @param value the value to set the attribute centroids to.
  #
  # source://tdigest//lib/tdigest/tdigest.rb#11
  def centroids=(_arg0); end

  # source://tdigest//lib/tdigest/tdigest.rb#98
  def compress!; end

  # source://tdigest//lib/tdigest/tdigest.rb#106
  def compression; end

  # source://tdigest//lib/tdigest/tdigest.rb#110
  def find_nearest(x); end

  # source://tdigest//lib/tdigest/tdigest.rb#129
  def merge!(other); end

  # source://tdigest//lib/tdigest/tdigest.rb#134
  def p_rank(x); end

  # source://tdigest//lib/tdigest/tdigest.rb#162
  def percentile(p); end

  # source://tdigest//lib/tdigest/tdigest.rb#190
  def push(x, n = T.unsafe(nil)); end

  # source://tdigest//lib/tdigest/tdigest.rb#195
  def push_centroid(c); end

  # source://tdigest//lib/tdigest/tdigest.rb#200
  def reset!; end

  # source://tdigest//lib/tdigest/tdigest.rb#207
  def size; end

  # source://tdigest//lib/tdigest/tdigest.rb#211
  def to_a; end

  private

  # source://tdigest//lib/tdigest/tdigest.rb#269
  def _add_weight(nearest, x, n); end

  # source://tdigest//lib/tdigest/tdigest.rb#283
  def _cumulate(exact = T.unsafe(nil), force = T.unsafe(nil)); end

  # source://tdigest//lib/tdigest/tdigest.rb#302
  def _digest(x, n); end

  # source://tdigest//lib/tdigest/tdigest.rb#341
  def _new_centroid(x, n, cumn); end

  class << self
    # source://tdigest//lib/tdigest/tdigest.rb#215
    def from_bytes(bytes); end

    # source://tdigest//lib/tdigest/tdigest.rb#260
    def from_json(array); end
  end
end

# source://tdigest//lib/tdigest/tdigest.rb#9
TDigest::TDigest::SMALL_ENCODING = T.let(T.unsafe(nil), Integer)

# source://tdigest//lib/tdigest/tdigest.rb#8
TDigest::TDigest::VERBOSE_ENCODING = T.let(T.unsafe(nil), Integer)

# source://tdigest//lib/tdigest/version.rb#4
TDigest::VERSION = T.let(T.unsafe(nil), String)
