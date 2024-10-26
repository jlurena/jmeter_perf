module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTMLAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#htmlassertion
    # @param [Hash] params Parameters for the HTMLAssertion element (default: `{}`).
    # @yield block to attach to the HTMLAssertion element
    # @return [JmeterPerf::HTMLAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def html_assertion(params = {}, &)
      node = JmeterPerf::HTMLAssertion.new(params)
      attach_node(node, &)
    end
  end

  class HTMLAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "HTMLAssertion" : (params[:name] || "HTMLAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <HTMLAssertion guiclass="HTMLAssertionGui" testclass="HTMLAssertion" testname="#{testname}" enabled="true">
          <longProp name="html_assertion_error_threshold">0</longProp>
          <longProp name="html_assertion_warning_threshold">0</longProp>
          <stringProp name="html_assertion_doctype">omit</stringProp>
          <boolProp name="html_assertion_errorsonly">false</boolProp>
          <longProp name="html_assertion_format">0</longProp>
          <stringProp name="html_assertion_filename"/>
        </HTMLAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
