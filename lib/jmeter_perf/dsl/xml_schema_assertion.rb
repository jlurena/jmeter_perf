module JmeterPerf
  class DSL
    def xml_schema_assertion(params={}, &block)
      node = JmeterPerf::XMLSchemaAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class XMLSchemaAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'XMLSchemaAssertion' : (params[:name] || 'XMLSchemaAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLSchemaAssertion guiclass="XMLSchemaAssertionGUI" testclass="XMLSchemaAssertion" testname="#{testname}" enabled="true">
  <stringProp name="xmlschema_assertion_filename"/>
</XMLSchemaAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
