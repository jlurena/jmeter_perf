module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element AJP13Sampler
    # @param [Hash] params Parameters for the AJP13Sampler element (default: `{}`).
    # @yield block to attach to the AJP13Sampler element
    # @return [JmeterPerf::AJP13Sampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ajp13sampler
    def ajp13_sampler(params = {}, &)
      node = AJP13Sampler.new(params)
      attach_node(node, &)
    end

    class AJP13Sampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "AJP13Sampler" : (params[:name] || "AJP13Sampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <AjpSampler guiclass="AjpSamplerGui" testclass="AjpSampler" testname="#{testname}" enabled="true">
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
            </AjpSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
