module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XPathAssertion
    # @param [Hash] params Parameters for the XPathAssertion element (default: `{}`).
    # @yield block to attach to the XPathAssertion element
    # @return [JmeterPerf::XPathAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xpathassertion
    def x_path_assertion(params = {}, &)
      node = XPathAssertion.new(params)
      attach_node(node, &)
    end

    class XPathAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "XPathAssertion" : (params[:name] || "XPathAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <XPathAssertion guiclass="XPathAssertionGui" testclass="XPathAssertion" testname="#{testname}" enabled="true">
              <boolProp name="XPath.negate">false</boolProp>
              <stringProp name="XPath.xpath">/</stringProp>
              <boolProp name="XPath.validate">false</boolProp>
              <boolProp name="XPath.whitespace">false</boolProp>
              <boolProp name="XPath.tolerant">false</boolProp>
              <boolProp name="XPath.namespace">false</boolProp>
              <stringProp name="Assertion.scope">all</stringProp>
            </XPathAssertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
