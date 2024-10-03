module JmeterPerf
  class DSL
    def jsr223_assertion(params={}, &block)
      node = JmeterPerf::JSR223Assertion.new(params)
      attach_node(node, &block)
    end
  end

  class JSR223Assertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'JSR223Assertion' : (params[:name] || 'JSR223Assertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
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
