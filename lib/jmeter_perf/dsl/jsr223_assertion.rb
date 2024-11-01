module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Assertion
    # @param params [Hash] Parameters for the JSR223Assertion element (default: `{}`).
    # @yield block to attach to the JSR223Assertion element
    # @return [JmeterPerf::JSR223Assertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223assertion
    def jsr223_assertion(params = {}, &)
      node = JSR223Assertion.new(params)
      attach_node(node, &)
    end

    class JSR223Assertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JSR223Assertion" : (params[:name] || "JSR223Assertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JSR223Assertion guiclass="TestBeanGUI" testclass="JSR223Assertion" testname="#{testname}" enabled="true">
              <stringProp name="cacheKey"/>
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </JSR223Assertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
