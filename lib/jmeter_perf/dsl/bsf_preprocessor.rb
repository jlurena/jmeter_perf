module JmeterPerf
  class DSL
    def bsf_preprocessor(params={}, &block)
      node = JmeterPerf::BSFPreprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class BSFPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'BSFPreprocessor' : (params[:name] || 'BSFPreprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFPreProcessor guiclass="TestBeanGUI" testclass="BSFPreProcessor" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFPreProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
