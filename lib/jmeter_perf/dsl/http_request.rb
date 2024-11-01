module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPRequest
    # @param params [Hash] Parameters for the HTTPRequest element (default: `{}`).
    # @yield block to attach to the HTTPRequest element
    # @return [JmeterPerf::HTTPRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httprequest
    def http_request(params = {}, &)
      node = HTTPRequest.new(params)
      attach_node(node, &)
    end

    class HTTPRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTTPRequest" : (params[:name] || "HTTPRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="#{testname}" enabled="true">
              <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <stringProp name="HTTPSampler.domain"/>
              <stringProp name="HTTPSampler.port"/>
              <stringProp name="HTTPSampler.connect_timeout"/>
              <stringProp name="HTTPSampler.response_timeout"/>
              <stringProp name="HTTPSampler.protocol"/>
              <stringProp name="HTTPSampler.contentEncoding"/>
              <stringProp name="HTTPSampler.path"/>
              <stringProp name="HTTPSampler.method">GET</stringProp>
              <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
              <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
              <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
              <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
              <boolProp name="HTTPSampler.monitor">false</boolProp>
              <stringProp name="HTTPSampler.embedded_url_re"/>
            </HTTPSamplerProxy>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
