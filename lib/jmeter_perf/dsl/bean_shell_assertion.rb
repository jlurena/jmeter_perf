module JmeterPerf
  class DSL
    def bean_shell_assertion(params={}, &block)
      node = JmeterPerf::BeanShellAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class BeanShellAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'BeanShellAssertion' : (params[:name] || 'BeanShellAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellAssertion guiclass="BeanShellAssertionGui" testclass="BeanShellAssertion" testname="#{testname}" enabled="true">
  <stringProp name="BeanShellAssertion.query"/>
  <stringProp name="BeanShellAssertion.filename"/>
  <stringProp name="BeanShellAssertion.parameters"/>
  <boolProp name="BeanShellAssertion.resetInterpreter">false</boolProp>
</BeanShellAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
