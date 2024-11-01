module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element IncludeController
    # @param params [Hash] Parameters for the IncludeController element (default: `{}`).
    # @yield block to attach to the IncludeController element
    # @return [JmeterPerf::IncludeController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#includecontroller
    def include_controller(params = {}, &)
      node = IncludeController.new(params)
      attach_node(node, &)
    end

    class IncludeController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "IncludeController" : (params[:name] || "IncludeController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <IncludeController guiclass="IncludeControllerGui" testclass="IncludeController" testname="#{testname}" enabled="true">
              <stringProp name="IncludeController.includepath"/>
            </IncludeController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
