module JmeterPerf
  class DSL
    def http_url_re_writing_modifier(params={}, &block)
      node = JmeterPerf::HTTPUrlRe_writingModifier.new(params)
      attach_node(node, &block)
    end
  end

  class HTTPUrlRe_writingModifier
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'HTTPUrlRe_writingModifier' : (params[:name] || 'HTTPUrlRe_writingModifier')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<URLRewritingModifier guiclass="URLRewritingModifierGui" testclass="URLRewritingModifier" testname="#{testname}" enabled="true">
  <stringProp name="argument_name"/>
  <boolProp name="path_extension">false</boolProp>
  <boolProp name="path_extension_no_equals">false</boolProp>
  <boolProp name="path_extension_no_questionmark">false</boolProp>
  <boolProp name="cache_value">false</boolProp>
  <boolProp name="encode">false</boolProp>
</URLRewritingModifier>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
