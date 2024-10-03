module JmeterPerf
  class DSL
    def bsf_timer(params={}, &block)
      node = JmeterPerf::BSFTimer.new(params)
      attach_node(node, &block)
    end
  end

  class BSFTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'BSFTimer' : (params[:name] || 'BSFTimer')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFTimer guiclass="TestBeanGUI" testclass="BSFTimer" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
