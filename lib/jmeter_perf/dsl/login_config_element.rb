module JmeterPerf
  class DSL
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
