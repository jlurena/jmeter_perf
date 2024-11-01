module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPCookieManager
    # @param params [Hash] Parameters for the HTTPCookieManager element (default: `{}`).
    # @yield block to attach to the HTTPCookieManager element
    # @return [JmeterPerf::HTTPCookieManager], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httpcookiemanager
    def http_cookie_manager(params = {}, &)
      node = HTTPCookieManager.new(params)
      attach_node(node, &)
    end

    class HTTPCookieManager
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTTPCookieManager" : (params[:name] || "HTTPCookieManager")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="#{testname}" enabled="true">
              <collectionProp name="CookieManager.cookies"/>
              <boolProp name="CookieManager.clearEachIteration">false</boolProp>
              <stringProp name="CookieManager.policy">default</stringProp>
              <stringProp name="CookieManager.implementation">org.apache.jmeter.protocol.http.control.HC4CookieHandler</stringProp>
            </CookieManager>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
