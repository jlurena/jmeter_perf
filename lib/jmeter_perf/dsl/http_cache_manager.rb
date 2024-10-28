module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPCacheManager
    # @param [Hash] params Parameters for the HTTPCacheManager element (default: `{}`).
    # @yield block to attach to the HTTPCacheManager element
    # @return [JmeterPerf::HTTPCacheManager], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httpcachemanager
    def http_cache_manager(params = {}, &)
      node = HTTPCacheManager.new(params)
      attach_node(node, &)
    end

    class HTTPCacheManager
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTTPCacheManager" : (params[:name] || "HTTPCacheManager")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <CacheManager guiclass="CacheManagerGui" testclass="CacheManager" testname="#{testname}" enabled="true">
              <boolProp name="clearEachIteration">false</boolProp>
              <boolProp name="useExpires">false</boolProp>
            </CacheManager>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
