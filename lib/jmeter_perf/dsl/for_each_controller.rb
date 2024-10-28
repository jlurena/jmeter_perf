module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ForEachController
    # @param [Hash] params Parameters for the ForEachController element (default: `{}`).
    # @yield block to attach to the ForEachController element
    # @return [JmeterPerf::ForEachController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#foreachcontroller
    def for_each_controller(params = {}, &)
      node = ForEachController.new(params)
      attach_node(node, &)
    end

    class ForEachController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "ForEachController" : (params[:name] || "ForEachController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ForeachController guiclass="ForeachControlPanel" testclass="ForeachController" testname="#{testname}" enabled="true">
              <stringProp name="ForeachController.inputVal"/>
              <stringProp name="ForeachController.returnVal"/>
              <boolProp name="ForeachController.useSeparator">true</boolProp>
            </ForeachController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
