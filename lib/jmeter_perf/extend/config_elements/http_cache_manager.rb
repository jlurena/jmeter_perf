module JmeterPerf
  class ExtendedDSL < DSL
    def http_cache_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.key? :clear_each_iteration
      params[:useExpires] = true if params.key? :use_expires

      super
    end

    alias_method :cache, :http_cache_manager
  end
end
