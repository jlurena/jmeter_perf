module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellSampler
    # @param [Hash] params Parameters for the BeanShellSampler element (default: `{}`).
    # @yield block to attach to the BeanShellSampler element
    # @return [JmeterPerf::BeanShellSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshellsampler
    def bean_shell_sampler(params = {}, &)
      node = BeanShellSampler.new(params)
      attach_node(node, &)
    end

    class BeanShellSampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BeanShellSampler" : (params[:name] || "BeanShellSampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BeanShellSampler guiclass="BeanShellSamplerGui" testclass="BeanShellSampler" testname="#{testname}" enabled="true">
              <stringProp name="BeanShellSampler.query"/>
              <stringProp name="BeanShellSampler.filename"/>
              <stringProp name="BeanShellSampler.parameters"/>
              <boolProp name="BeanShellSampler.resetInterpreter">false</boolProp>
            </BeanShellSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
