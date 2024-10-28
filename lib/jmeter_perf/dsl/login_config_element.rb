module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LoginConfigElement
    # @param [Hash] params Parameters for the LoginConfigElement element (default: `{}`).
    # @yield block to attach to the LoginConfigElement element
    # @return [JmeterPerf::LoginConfigElement], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#loginconfigelement
    def login_config_element(params = {}, &)
      node = LoginConfigElement.new(params)
      attach_node(node, &)
    end

    class LoginConfigElement
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "LoginConfigElement" : (params[:name] || "LoginConfigElement")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConfigTestElement guiclass="LoginConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
              <stringProp name="ConfigTestElement.username"/>
              <stringProp name="ConfigTestElement.password"/>
            </ConfigTestElement>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
