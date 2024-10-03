module JmeterPerf
  class DSL
    def bsf_listener(params={}, &block)
      node = JmeterPerf::BSFListener.new(params)
      attach_node(node, &block)
    end
  end

  class BSFListener
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'BSFListener' : (params[:name] || 'BSFListener')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFListener guiclass="TestBeanGUI" testclass="BSFListener" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFListener>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
