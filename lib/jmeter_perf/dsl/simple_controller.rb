module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SimpleController
    # @param params [Hash] Parameters for the SimpleController element (default: `{}`).
    # @yield block to attach to the SimpleController element
    # @return [JmeterPerf::SimpleController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#simplecontroller
    def simple_controller(params = {}, &)
      node = SimpleController.new(params)
      attach_node(node, &)
    end

    class SimpleController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "SimpleController" : (params[:name] || "SimpleController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <GenericController guiclass="LogicControllerGui" testclass="GenericController" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
