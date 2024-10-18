module JmeterPerf
  class DSL
    def if_controller(params = {}, &)
      node = JmeterPerf::IfController.new(params)
      attach_node(node, &)
    end
  end

  class IfController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "IfController" : (params[:name] || "IfController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <IfController guiclass="IfControllerPanel" testclass="IfController" testname="#{testname}" enabled="true">
          <stringProp name="IfController.condition"/>
          <boolProp name="IfController.evaluateAll">false</boolProp>
          <boolProp name="IfController.useExpression">true</boolProp>
        </IfController>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
