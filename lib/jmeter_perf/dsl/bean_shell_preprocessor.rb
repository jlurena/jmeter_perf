module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellPreprocessor
    # @param [Hash] params Parameters for the BeanShellPreprocessor element (default: `{}`).
    # @yield block to attach to the BeanShellPreprocessor element
    # @return [JmeterPerf::BeanShellPreprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshellpreprocessor
    def bean_shell_preprocessor(params = {}, &)
      node = BeanShellPreprocessor.new(params)
      attach_node(node, &)
    end

    class BeanShellPreprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BeanShellPreprocessor" : (params[:name] || "BeanShellPreprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BeanShellPreProcessor guiclass="TestBeanGUI" testclass="BeanShellPreProcessor" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <boolProp name="resetInterpreter">false</boolProp>
              <stringProp name="script"/>
            </BeanShellPreProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
