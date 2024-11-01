module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPAuthorizationManager
    # @param params [Hash] Parameters for the HTTPAuthorizationManager element (default: `{}`).
    # @yield block to attach to the HTTPAuthorizationManager element
    # @return [JmeterPerf::HTTPAuthorizationManager], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httpauthorizationmanager
    def http_authorization_manager(params = {}, &)
      node = HTTPAuthorizationManager.new(params)
      attach_node(node, &)
    end

    class HTTPAuthorizationManager
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTTPAuthorizationManager" : (params[:name] || "HTTPAuthorizationManager")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
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
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
