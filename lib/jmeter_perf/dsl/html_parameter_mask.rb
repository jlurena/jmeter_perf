module JmeterPerf
  class DSL
    def html_parameter_mask(params = {}, &)
      node = JmeterPerf::HTMLParameterMask.new(params)
      attach_node(node, &)
    end
  end

  class HTMLParameterMask
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "HTMLParameterMask" : (params[:name] || "HTMLParameterMask")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ConfigTestElement guiclass="ObsoleteGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
          <elementProp name="ParamModifier.mask" elementType="ConfigTestElement">
            <stringProp name="ParamModifier.field_name"/>
            <stringProp name="ParamModifier.prefix"/>
            <longProp name="ParamModifier.lower_bound">0</longProp>
            <longProp name="ParamModifier.upper_bound">10</longProp>
            <longProp name="ParamModifier.increment">1</longProp>
            <stringProp name="ParamModifier.suffix"/>
          </elementProp>
        </ConfigTestElement>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
