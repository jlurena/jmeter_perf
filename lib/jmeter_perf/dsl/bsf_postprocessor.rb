module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFPostprocessor
    # @param params [Hash] Parameters for the BSFPostprocessor element (default: `{}`).
    # @yield block to attach to the BSFPostprocessor element
    # @return [JmeterPerf::BSFPostprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfpostprocessor
    def bsf_postprocessor(params = {}, &)
      node = BSFPostprocessor.new(params)
      attach_node(node, &)
    end

    class BSFPostprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BSFPostprocessor" : (params[:name] || "BSFPostprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BSFPostProcessor guiclass="TestBeanGUI" testclass="BSFPostProcessor" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </BSFPostProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
