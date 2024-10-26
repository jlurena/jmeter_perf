module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPCacheManager
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httpcachemanager
    # @param [Hash] params Parameters for the HTTPCacheManager element (default: `{}`).
    # @yield block to attach to the HTTPCacheManager element
    # @return [JmeterPerf::HTTPCacheManager], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def http_cache_manager(params = {}, &)
      node = JmeterPerf::HTTPCacheManager.new(params)
      attach_node(node, &)
    end
  end

  class HTTPCacheManager
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "HTTPCacheManager" : (params[:name] || "HTTPCacheManager")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <CacheManager guiclass="CacheManagerGui" testclass="CacheManager" testname="#{testname}" enabled="true">
          <boolProp name="clearEachIteration">false</boolProp>
          <boolProp name="useExpires">false</boolProp>
        </CacheManager>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
