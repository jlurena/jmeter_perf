module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPUrlRewritingModifier
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httpurlrewritingmodifier
    # @param [Hash] params Parameters for the HTTPUrlRewritingModifier element (default: `{}`).
    # @yield block to attach to the HTTPUrlRewritingModifier element
    # @return [JmeterPerf::HTTPUrlRewritingModifier], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def http_url_rewriting_modifier(params = {}, &)
      node = JmeterPerf::HTTPUrlRewritingModifier.new(params)
      attach_node(node, &)
    end
  end

  class HTTPUrlRewritingModifier
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "HTTPUrlRewritingModifier" : (params[:name] || "HTTPUrlRewritingModifier")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
