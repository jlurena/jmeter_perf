module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LDAPExtendedRequest
    # @param [Hash] params Parameters for the LDAPExtendedRequest element (default: `{}`).
    # @yield block to attach to the LDAPExtendedRequest element
    # @return [JmeterPerf::LDAPExtendedRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ldapextendedrequest
    def ldap_extended_request(params = {}, &)
      node = LDAPExtendedRequest.new(params)
      attach_node(node, &)
    end

    class LDAPExtendedRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "LDAPExtendedRequest" : (params[:name] || "LDAPExtendedRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <LDAPExtSampler guiclass="LdapExtTestSamplerGui" testclass="LDAPExtSampler" testname="#{testname}" enabled="true">
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
            </LDAPExtSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
