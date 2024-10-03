module JmeterPerf
  class DSL
    def bean_shell_postprocessor(params={}, &block)
      node = JmeterPerf::BeanShellPostprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class BeanShellPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'BeanShellPostprocessor' : (params[:name] || 'BeanShellPostprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellPostProcessor guiclass="TestBeanGUI" testclass="BeanShellPostProcessor" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellPostProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
