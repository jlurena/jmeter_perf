module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Timer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223timer
    # @param [Hash] params Parameters for the JSR223Timer element (default: `{}`).
    # @yield block to attach to the JSR223Timer element
    # @return [JmeterPerf::JSR223Timer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def jsr223_timer(params = {}, &)
      node = JmeterPerf::JSR223Timer.new(params)
      attach_node(node, &)
    end
  end

  class JSR223Timer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSR223Timer" : (params[:name] || "JSR223Timer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <JSR223Timer guiclass="TestBeanGUI" testclass="JSR223Timer" testname="#{testname}" enabled="true">
          <stringProp name="cacheKey"/>
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </JSR223Timer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
