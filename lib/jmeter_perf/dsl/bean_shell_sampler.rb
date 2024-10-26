module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellSampler
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshellsampler
    # @param [Hash] params Parameters for the BeanShellSampler element (default: `{}`).
    # @yield block to attach to the BeanShellSampler element
    # @return [JmeterPerf::BeanShellSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bean_shell_sampler(params = {}, &)
      node = JmeterPerf::BeanShellSampler.new(params)
      attach_node(node, &)
    end
  end

  class BeanShellSampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BeanShellSampler" : (params[:name] || "BeanShellSampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BeanShellSampler guiclass="BeanShellSamplerGui" testclass="BeanShellSampler" testname="#{testname}" enabled="true">
          <stringProp name="BeanShellSampler.query"/>
          <stringProp name="BeanShellSampler.filename"/>
          <stringProp name="BeanShellSampler.parameters"/>
          <boolProp name="BeanShellSampler.resetInterpreter">false</boolProp>
        </BeanShellSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
