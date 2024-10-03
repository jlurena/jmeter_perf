module JmeterPerf
  class DSL
    def bean_shell_preprocessor(params={}, &block)
      node = JmeterPerf::BeanShellPreprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class BeanShellPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'BeanShellPreprocessor' : (params[:name] || 'BeanShellPreprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellPreProcessor guiclass="TestBeanGUI" testclass="BeanShellPreProcessor" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellPreProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
