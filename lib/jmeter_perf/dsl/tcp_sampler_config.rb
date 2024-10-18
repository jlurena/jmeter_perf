module JmeterPerf
  class DSL
    def tcp_sampler_config(params = {}, &)
      node = JmeterPerf::TCPSamplerConfig.new(params)
      attach_node(node, &)
    end
  end

  class TCPSamplerConfig
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "TCPSamplerConfig" : (params[:name] || "TCPSamplerConfig")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
