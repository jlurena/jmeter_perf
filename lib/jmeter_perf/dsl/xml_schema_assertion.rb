module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XMLSchemaAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xmlschemaassertion
    # @param [Hash] params Parameters for the XMLSchemaAssertion element (default: `{}`).
    # @yield block to attach to the XMLSchemaAssertion element
    # @return [JmeterPerf::XMLSchemaAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def xml_schema_assertion(params = {}, &)
      node = JmeterPerf::XMLSchemaAssertion.new(params)
      attach_node(node, &)
    end
  end

  class XMLSchemaAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "XMLSchemaAssertion" : (params[:name] || "XMLSchemaAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <XMLSchemaAssertion guiclass="XMLSchemaAssertionGUI" testclass="XMLSchemaAssertion" testname="#{testname}" enabled="true">
          <stringProp name="xmlschema_assertion_filename"/>
        </XMLSchemaAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
