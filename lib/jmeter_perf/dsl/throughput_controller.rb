module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ThroughputController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#throughputcontroller
    # @param [Hash] params Parameters for the ThroughputController element (default: `{}`).
    # @yield block to attach to the ThroughputController element
    # @return [JmeterPerf::ThroughputController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def throughput_controller(params = {}, &)
      node = JmeterPerf::ThroughputController.new(params)
      attach_node(node, &)
    end
  end

  class ThroughputController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "ThroughputController" : (params[:name] || "ThroughputController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ThroughputController guiclass="ThroughputControllerGui" testclass="ThroughputController" testname="#{testname}" enabled="true">
          <intProp name="ThroughputController.style">0</intProp>
          <boolProp name="ThroughputController.perThread">false</boolProp>
          <intProp name="ThroughputController.maxThroughput">1</intProp>
          <FloatProperty>
            <name>ThroughputController.percentThroughput</name>
            <value>100.0</value>
            <savedValue>0.0</savedValue>
          </FloatProperty>
        </ThroughputController>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
