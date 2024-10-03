module JmeterPerf
  class DSL
    def jsr223_preprocessor(params={}, &block)
      node = JmeterPerf::JSR223Preprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class JSR223Preprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'JSR223Preprocessor' : (params[:name] || 'JSR223Preprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223PreProcessor guiclass="TestBeanGUI" testclass="JSR223PreProcessor" testname="#{testname}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223PreProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
