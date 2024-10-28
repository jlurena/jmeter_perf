module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element DebugSampler
    # @param [Hash] params Parameters for the DebugSampler element (default: `{}`).
    # @yield block to attach to the DebugSampler element
    # @return [JmeterPerf::DebugSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#debugsampler
    def debug_sampler(params = {}, &)
      node = DebugSampler.new(params)
      attach_node(node, &)
    end

    class DebugSampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "DebugSampler" : (params[:name] || "DebugSampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <DebugSampler guiclass="TestBeanGUI" testclass="DebugSampler" testname="#{testname}" enabled="true">
              <boolProp name="displayJMeterProperties">false</boolProp>
              <boolProp name="displayJMeterVariables">true</boolProp>
              <boolProp name="displaySystemProperties">false</boolProp>
            </DebugSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
