module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element LoginConfigElement
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#loginconfigelement
    # @param [Hash] params Parameters for the LoginConfigElement element (default: `{}`).
    # @yield block to attach to the LoginConfigElement element
    # @return [JmeterPerf::LoginConfigElement], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def login_config_element(params = {}, &)
      node = JmeterPerf::LoginConfigElement.new(params)
      attach_node(node, &)
    end
  end

  class LoginConfigElement
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "LoginConfigElement" : (params[:name] || "LoginConfigElement")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ConfigTestElement guiclass="LoginConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
          <stringProp name="ConfigTestElement.username"/>
          <stringProp name="ConfigTestElement.password"/>
        </ConfigTestElement>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
