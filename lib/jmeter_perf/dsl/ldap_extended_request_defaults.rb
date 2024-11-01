module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LDAPExtendedRequestDefaults
    # @param params [Hash] Parameters for the LDAPExtendedRequestDefaults element (default: `{}`).
    # @yield block to attach to the LDAPExtendedRequestDefaults element
    # @return [JmeterPerf::LDAPExtendedRequestDefaults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ldapextendedrequestdefaults
    def ldap_extended_request_defaults(params = {}, &)
      node = LDAPExtendedRequestDefaults.new(params)
      attach_node(node, &)
    end

    class LDAPExtendedRequestDefaults
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "LDAPExtendedRequestDefaults" : (params[:name] || "LDAPExtendedRequestDefaults")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConfigTestElement guiclass="LdapExtConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
              <stringProp name="servername"/>
              <stringProp name="port"/>
              <stringProp name="rootdn"/>
              <stringProp name="scope">2</stringProp>
              <stringProp name="countlimit"/>
              <stringProp name="timelimit"/>
              <stringProp name="attributes"/>
              <stringProp name="return_object">false</stringProp>
              <stringProp name="deref_aliases">false</stringProp>
              <stringProp name="connection_timeout"/>
              <stringProp name="parseflag">false</stringProp>
              <stringProp name="secure">false</stringProp>
              <stringProp name="user_dn"/>
              <stringProp name="user_pw"/>
              <stringProp name="comparedn"/>
              <stringProp name="comparefilt"/>
              <stringProp name="modddn"/>
              <stringProp name="newdn"/>
            </ConfigTestElement>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
