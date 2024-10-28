module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XMLSchemaAssertion
    # @param [Hash] params Parameters for the XMLSchemaAssertion element (default: `{}`).
    # @yield block to attach to the XMLSchemaAssertion element
    # @return [JmeterPerf::XMLSchemaAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xmlschemaassertion
    def xml_schema_assertion(params = {}, &)
      node = XMLSchemaAssertion.new(params)
      attach_node(node, &)
    end

    class XMLSchemaAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "XMLSchemaAssertion" : (params[:name] || "XMLSchemaAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <XMLSchemaAssertion guiclass="XMLSchemaAssertionGUI" testclass="XMLSchemaAssertion" testname="#{testname}" enabled="true">
              <stringProp name="xmlschema_assertion_filename"/>
            </XMLSchemaAssertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
