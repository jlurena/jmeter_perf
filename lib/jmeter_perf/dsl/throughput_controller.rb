module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ThroughputController
    # @param params [Hash] Parameters for the ThroughputController element (default: `{}`).
    # @yield block to attach to the ThroughputController element
    # @return [JmeterPerf::ThroughputController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#throughputcontroller
    def throughput_controller(params = {}, &)
      node = ThroughputController.new(params)
      attach_node(node, &)
    end

    class ThroughputController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "ThroughputController" : (params[:name] || "ThroughputController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
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
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
