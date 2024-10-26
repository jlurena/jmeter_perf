module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellListener
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshelllistener
    # @param [Hash] params Parameters for the BeanShellListener element (default: `{}`).
    # @yield block to attach to the BeanShellListener element
    # @return [JmeterPerf::BeanShellListener], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
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
