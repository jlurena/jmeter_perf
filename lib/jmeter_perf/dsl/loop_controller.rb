module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LoopController
    # @param params [Hash] Parameters for the LoopController element (default: `{}`).
    # @yield block to attach to the LoopController element
    # @return [JmeterPerf::LoopController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#loopcontroller
    def loop_controller(params = {}, &)
      node = LoopController.new(params)
      attach_node(node, &)
    end

    class LoopController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "LoopController" : (params[:name] || "LoopController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <LoopController guiclass="LoopControlPanel" testclass="LoopController" testname="#{testname}" enabled="true">
              <boolProp name="LoopController.continue_forever">true</boolProp>
              <stringProp name="LoopController.loops">1</stringProp>
            </LoopController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
