module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element DebugPostprocessor
    # @param params [Hash] Parameters for the DebugPostprocessor element (default: `{}`).
    # @yield block to attach to the DebugPostprocessor element
    # @return [JmeterPerf::DebugPostprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#debugpostprocessor
    def debug_postprocessor(params = {}, &)
      node = DebugPostprocessor.new(params)
      attach_node(node, &)
    end

    class DebugPostprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "DebugPostprocessor" : (params[:name] || "DebugPostprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <DebugPostProcessor guiclass="TestBeanGUI" testclass="DebugPostProcessor" testname="#{testname}" enabled="true">
              <boolProp name="displayJMeterProperties">false</boolProp>
              <boolProp name="displayJMeterVariables">true</boolProp>
              <boolProp name="displaySamplerProperties">true</boolProp>
              <boolProp name="displaySystemProperties">false</boolProp>
            </DebugPostProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
