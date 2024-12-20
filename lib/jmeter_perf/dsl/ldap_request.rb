module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LDAPRequest
    # @param params [Hash] Parameters for the LDAPRequest element (default: `{}`).
    # @yield block to attach to the LDAPRequest element
    # @return [JmeterPerf::LDAPRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ldaprequest
    def ldap_request(params = {}, &)
      node = LDAPRequest.new(params)
      attach_node(node, &)
    end

    class LDAPRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "LDAPRequest" : (params[:name] || "LDAPRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <LDAPSampler guiclass="LdapTestSamplerGui" testclass="LDAPSampler" testname="#{testname}" enabled="true">
              <stringProp name="servername"/>
              <stringProp name="port"/>
              <stringProp name="rootdn"/>
              <boolProp name="user_defined">false</boolProp>
              <stringProp name="test">add</stringProp>
              <stringProp name="base_entry_dn"/>
              <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <stringProp name="ConfigTestElement.username"/>
              <stringProp name="ConfigTestElement.password"/>
            </LDAPSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
