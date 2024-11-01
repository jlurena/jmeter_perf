module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Postprocessor
    # @param params [Hash] Parameters for the JSR223Postprocessor element (default: `{}`).
    # @yield block to attach to the JSR223Postprocessor element
    # @return [JmeterPerf::JSR223Postprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223postprocessor
    def jsr223_postprocessor(params = {}, &)
      node = JSR223Postprocessor.new(params)
      attach_node(node, &)
    end

    class JSR223Postprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JSR223Postprocessor" : (params[:name] || "JSR223Postprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JSR223PostProcessor guiclass="TestBeanGUI" testclass="JSR223PostProcessor" testname="#{testname}" enabled="true">
              <stringProp name="cacheKey"/>
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </JSR223PostProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
