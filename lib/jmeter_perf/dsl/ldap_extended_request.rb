module JmeterPerf
  class DSL
    def ldap_extended_request(params = {}, &)
      node = JmeterPerf::LDAPExtendedRequest.new(params)
      attach_node(node, &)
    end
  end

  class LDAPExtendedRequest
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "LDAPExtendedRequest" : (params[:name] || "LDAPExtendedRequest")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
