module JmeterPerf
  class DSL
    def bean_shell_listener(params = {}, &)
      node = JmeterPerf::BeanShellListener.new(params)
      attach_node(node, &)
    end
  end

  class BeanShellListener
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BeanShellListener" : (params[:name] || "BeanShellListener")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BeanShellListener guiclass="TestBeanGUI" testclass="BeanShellListener" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <boolProp name="resetInterpreter">false</boolProp>
          <stringProp name="script"/>
        </BeanShellListener>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
