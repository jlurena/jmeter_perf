module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element CompareAssertion
    # @param [Hash] params Parameters for the CompareAssertion element (default: `{}`).
    # @yield block to attach to the CompareAssertion element
    # @return [JmeterPerf::CompareAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#compareassertion
    def compare_assertion(params = {}, &)
      node = CompareAssertion.new(params)
      attach_node(node, &)
    end

    class CompareAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "CompareAssertion" : (params[:name] || "CompareAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <CompareAssertion guiclass="TestBeanGUI" testclass="CompareAssertion" testname="#{testname}" enabled="true">
              <boolProp name="compareContent">true</boolProp>
              <longProp name="compareTime">-1</longProp>
              <collectionProp name="stringsToSkip"/>
            </CompareAssertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
