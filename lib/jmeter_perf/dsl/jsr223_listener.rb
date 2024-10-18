module JmeterPerf
  class DSL
    def jsr223_listener(params = {}, &)
      node = JmeterPerf::JSR223Listener.new(params)
      attach_node(node, &)
    end
  end

  class JSR223Listener
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSR223Listener" : (params[:name] || "JSR223Listener")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <JSR223Listener guiclass="TestBeanGUI" testclass="JSR223Listener" testname="#{testname}" enabled="true">
          <stringProp name="cacheKey"/>
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </JSR223Listener>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
