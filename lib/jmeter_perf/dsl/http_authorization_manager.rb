module JmeterPerf
  class DSL
    def http_authorization_manager(params={}, &block)
      node = JmeterPerf::HTTPAuthorizationManager.new(params)
      attach_node(node, &block)
    end
  end

  class HTTPAuthorizationManager
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'HTTPAuthorizationManager' : (params[:name] || 'HTTPAuthorizationManager')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AuthManager guiclass="AuthPanel" testclass="AuthManager" testname="#{testname}" enabled="true">
  <collectionProp name="AuthManager.auth_list">
    <elementProp name="" elementType="Authorization">
      <stringProp name="Authorization.url"/>
      <stringProp name="Authorization.username"/>
      <stringProp name="Authorization.password"/>
      <stringProp name="Authorization.domain"/>
      <stringProp name="Authorization.realm"/>
    </elementProp>
  </collectionProp>
</AuthManager>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
