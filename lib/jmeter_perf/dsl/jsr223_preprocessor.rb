module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Preprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223preprocessor
    # @param [Hash] params Parameters for the JSR223Preprocessor element (default: `{}`).
    # @yield block to attach to the JSR223Preprocessor element
    # @return [JmeterPerf::JSR223Preprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def jsr223_preprocessor(params = {}, &)
      node = JmeterPerf::JSR223Preprocessor.new(params)
      attach_node(node, &)
    end
  end

  class JSR223Preprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSR223Preprocessor" : (params[:name] || "JSR223Preprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <JSR223PreProcessor guiclass="TestBeanGUI" testclass="JSR223PreProcessor" testname="#{testname}" enabled="true">
          <stringProp name="cacheKey"/>
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </JSR223PreProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
