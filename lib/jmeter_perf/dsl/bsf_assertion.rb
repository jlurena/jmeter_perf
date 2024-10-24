module JmeterPerf
  class DSL
    def bsf_assertion(params = {}, &)
      node = JmeterPerf::BSFAssertion.new(params)
      attach_node(node, &)
    end
  end

  class BSFAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFAssertion" : (params[:name] || "BSFAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFAssertion guiclass="TestBeanGUI" testclass="BSFAssertion" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
