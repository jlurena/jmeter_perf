module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTMLParameterMask
    # @param [Hash] params Parameters for the HTMLParameterMask element (default: `{}`).
    # @yield block to attach to the HTMLParameterMask element
    # @return [JmeterPerf::HTMLParameterMask], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#htmlparametermask
    def html_parameter_mask(params = {}, &)
      node = HTMLParameterMask.new(params)
      attach_node(node, &)
    end

    class HTMLParameterMask
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTMLParameterMask" : (params[:name] || "HTMLParameterMask")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
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
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
