module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element IfController
    # @param params [Hash] Parameters for the IfController element (default: `{}`).
    # @yield block to attach to the IfController element
    # @return [JmeterPerf::IfController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ifcontroller
    def if_controller(params = {}, &)
      node = IfController.new(params)
      attach_node(node, &)
    end

    class IfController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "IfController" : (params[:name] || "IfController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <IfController guiclass="IfControllerPanel" testclass="IfController" testname="#{testname}" enabled="true">
              <stringProp name="IfController.condition"/>
              <boolProp name="IfController.evaluateAll">false</boolProp>
              <boolProp name="IfController.useExpression">true</boolProp>
            </IfController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
