module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFAssertion
    # @param [Hash] params Parameters for the BSFAssertion element (default: `{}`).
    # @yield block to attach to the BSFAssertion element
    # @return [JmeterPerf::BSFAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfassertion
    def bsf_assertion(params = {}, &)
      node = BSFAssertion.new(params)
      attach_node(node, &)
    end

    class BSFAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BSFAssertion" : (params[:name] || "BSFAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BSFAssertion guiclass="TestBeanGUI" testclass="BSFAssertion" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </BSFAssertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
