module JmeterPerf
  class DSL
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
