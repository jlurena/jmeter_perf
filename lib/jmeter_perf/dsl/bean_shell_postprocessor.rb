module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellPostprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshellpostprocessor
    # @param [Hash] params Parameters for the BeanShellPostprocessor element (default: `{}`).
    # @yield block to attach to the BeanShellPostprocessor element
    # @return [JmeterPerf::BeanShellPostprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bean_shell_postprocessor(params = {}, &)
      node = JmeterPerf::BeanShellPostprocessor.new(params)
      attach_node(node, &)
    end
  end

  class BeanShellPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BeanShellPostprocessor" : (params[:name] || "BeanShellPostprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
