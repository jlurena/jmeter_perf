module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Preprocessor
    # @param [Hash] params Parameters for the JSR223Preprocessor element (default: `{}`).
    # @yield block to attach to the JSR223Preprocessor element
    # @return [JmeterPerf::JSR223Preprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223preprocessor
    def jsr223_preprocessor(params = {}, &)
      node = JSR223Preprocessor.new(params)
      attach_node(node, &)
    end

    class JSR223Preprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JSR223Preprocessor" : (params[:name] || "JSR223Preprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JSR223PreProcessor guiclass="TestBeanGUI" testclass="JSR223PreProcessor" testname="#{testname}" enabled="true">
              <stringProp name="cacheKey"/>
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </JSR223PreProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
