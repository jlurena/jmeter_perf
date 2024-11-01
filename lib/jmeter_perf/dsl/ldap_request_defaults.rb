module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LDAPRequestDefaults
    # @param params [Hash] Parameters for the LDAPRequestDefaults element (default: `{}`).
    # @yield block to attach to the LDAPRequestDefaults element
    # @return [JmeterPerf::LDAPRequestDefaults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ldaprequestdefaults
    def ldap_request_defaults(params = {}, &)
      node = LDAPRequestDefaults.new(params)
      attach_node(node, &)
    end

    class LDAPRequestDefaults
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "LDAPRequestDefaults" : (params[:name] || "LDAPRequestDefaults")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConfigTestElement guiclass="LdapConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
              <stringProp name="servername"/>
              <stringProp name="port"/>
              <stringProp name="rootdn"/>
              <boolProp name="user_defined">true</boolProp>
              <stringProp name="test">add</stringProp>
              <stringProp name="base_entry_dn"/>
              <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments">
                  <elementProp name=" " elementType="Argument">
                    <stringProp name="Argument.name"> </stringProp>
                    <stringProp name="Argument.value"> </stringProp>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                </collectionProp>
              </elementProp>
            </ConfigTestElement>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
