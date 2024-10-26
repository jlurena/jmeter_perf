module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Postprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223postprocessor
    # @param [Hash] params Parameters for the JSR223Postprocessor element (default: `{}`).
    # @yield block to attach to the JSR223Postprocessor element
    # @return [JmeterPerf::JSR223Postprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def jsr223_postprocessor(params = {}, &)
      node = JmeterPerf::JSR223Postprocessor.new(params)
      attach_node(node, &)
    end
  end

  class JSR223Postprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSR223Postprocessor" : (params[:name] || "JSR223Postprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <JSR223PostProcessor guiclass="TestBeanGUI" testclass="JSR223PostProcessor" testname="#{testname}" enabled="true">
          <stringProp name="cacheKey"/>
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </JSR223PostProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
