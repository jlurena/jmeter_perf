module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element WhileController
    # @param [Hash] params Parameters for the WhileController element (default: `{}`).
    # @yield block to attach to the WhileController element
    # @return [JmeterPerf::WhileController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#whilecontroller
    def while_controller(params = {}, &)
      node = WhileController.new(params)
      attach_node(node, &)
    end

    class WhileController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "WhileController" : (params[:name] || "WhileController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <WhileController guiclass="WhileControllerGui" testclass="WhileController" testname="#{testname}" enabled="true">
              <stringProp name="WhileController.condition"/>
            </WhileController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
