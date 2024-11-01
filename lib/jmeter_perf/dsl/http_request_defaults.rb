module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPRequestDefaults
    # @param params [Hash] Parameters for the HTTPRequestDefaults element (default: `{}`).
    # @yield block to attach to the HTTPRequestDefaults element
    # @return [JmeterPerf::HTTPRequestDefaults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httprequestdefaults
    def http_request_defaults(params = {}, &)
      node = HTTPRequestDefaults.new(params)
      attach_node(node, &)
    end

    class HTTPRequestDefaults
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTTPRequestDefaults" : (params[:name] || "HTTPRequestDefaults")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConfigTestElement guiclass="HttpDefaultsGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
              <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments">
                  <elementProp name="" elementType="HTTPArgument">
                    <boolProp name="HTTPArgument.always_encode">false</boolProp>
                    <stringProp name="Argument.value">username=my_name&amp;password=my_password&amp;email="my name &lt;test@example.com&gt;"</stringProp>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                </collectionProp>
              </elementProp>
              <stringProp name="HTTPSampler.domain"/>
              <stringProp name="HTTPSampler.port"/>
              <stringProp name="HTTPSampler.proxyHost"/>
              <stringProp name="HTTPSampler.proxyPort"/>
              <stringProp name="HTTPSampler.connect_timeout"/>
              <stringProp name="HTTPSampler.response_timeout"/>
              <stringProp name="HTTPSampler.protocol"/>
              <stringProp name="HTTPSampler.contentEncoding"/>
              <stringProp name="HTTPSampler.path">/</stringProp>
              <stringProp name="HTTPSampler.implementation">HttpClient4</stringProp>
              <boolProp name="HTTPSampler.image_parser">true</boolProp>
              <boolProp name="HTTPSampler.concurrentDwn">true</boolProp>
              <stringProp name="HTTPSampler.concurrentPool">4</stringProp>
              <stringProp name="HTTPSampler.embedded_url_re"/>
            </ConfigTestElement>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
