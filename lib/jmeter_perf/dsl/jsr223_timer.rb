module JmeterPerf
  class DSL
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
