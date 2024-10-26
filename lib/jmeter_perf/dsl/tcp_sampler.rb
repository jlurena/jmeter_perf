module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TCPSampler
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#tcpsampler
    # @param [Hash] params Parameters for the TCPSampler element (default: `{}`).
    # @yield block to attach to the TCPSampler element
    # @return [JmeterPerf::TCPSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def tcp_sampler(params = {}, &)
      node = JmeterPerf::TCPSampler.new(params)
      attach_node(node, &)
    end
  end

  class TCPSampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "TCPSampler" : (params[:name] || "TCPSampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <TCPSampler guiclass="TCPSamplerGui" testclass="TCPSampler" testname="#{testname}" enabled="true">
          <stringProp name="TCPSampler.server"/>
          <boolProp name="TCPSampler.reUseConnection">true</boolProp>
          <stringProp name="TCPSampler.port"/>
          <boolProp name="TCPSampler.nodelay">false</boolProp>
          <stringProp name="TCPSampler.timeout"/>
          <stringProp name="TCPSampler.request"/>
          <boolProp name="TCPSampler.closeConnection">false</boolProp>
          <stringProp name="ConfigTestElement.username"/>
          <stringProp name="ConfigTestElement.password"/>
        </TCPSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
