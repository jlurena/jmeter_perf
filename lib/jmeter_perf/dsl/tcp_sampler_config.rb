module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TCPSamplerConfig
    # @param params [Hash] Parameters for the TCPSamplerConfig element (default: `{}`).
    # @yield block to attach to the TCPSamplerConfig element
    # @return [JmeterPerf::TCPSamplerConfig], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#tcpsamplerconfig
    def tcp_sampler_config(params = {}, &)
      node = TCPSamplerConfig.new(params)
      attach_node(node, &)
    end

    class TCPSamplerConfig
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "TCPSamplerConfig" : (params[:name] || "TCPSamplerConfig")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConfigTestElement guiclass="TCPConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
              <stringProp name="TCPSampler.server"/>
              <boolProp name="TCPSampler.reUseConnection">true</boolProp>
              <stringProp name="TCPSampler.port"/>
              <boolProp name="TCPSampler.nodelay">false</boolProp>
              <stringProp name="TCPSampler.timeout"/>
              <stringProp name="TCPSampler.request"/>
              <boolProp name="TCPSampler.closeConnection">false</boolProp>
            </ConfigTestElement>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
