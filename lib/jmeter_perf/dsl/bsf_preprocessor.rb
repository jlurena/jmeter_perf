module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFPreprocessor
    # @param params [Hash] Parameters for the BSFPreprocessor element (default: `{}`).
    # @yield block to attach to the BSFPreprocessor element
    # @return [JmeterPerf::BSFPreprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfpreprocessor
    def bsf_preprocessor(params = {}, &)
      node = BSFPreprocessor.new(params)
      attach_node(node, &)
    end

    class BSFPreprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BSFPreprocessor" : (params[:name] || "BSFPreprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BSFPreProcessor guiclass="TestBeanGUI" testclass="BSFPreProcessor" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </BSFPreProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
