module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Assertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223assertion
    # @param [Hash] params Parameters for the JSR223Assertion element (default: `{}`).
    # @yield block to attach to the JSR223Assertion element
    # @return [JmeterPerf::JSR223Assertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def jsr223_assertion(params = {}, &)
      node = JmeterPerf::JSR223Assertion.new(params)
      attach_node(node, &)
    end
  end

  class JSR223Assertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSR223Assertion" : (params[:name] || "JSR223Assertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <JSR223Assertion guiclass="TestBeanGUI" testclass="JSR223Assertion" testname="#{testname}" enabled="true">
          <stringProp name="cacheKey"/>
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </JSR223Assertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
