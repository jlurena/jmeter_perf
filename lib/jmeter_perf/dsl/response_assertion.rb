module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ResponseAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#responseassertion
    # @param [Hash] params Parameters for the ResponseAssertion element (default: `{}`).
    # @yield block to attach to the ResponseAssertion element
    # @return [JmeterPerf::ResponseAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def response_assertion(params = {}, &)
      node = JmeterPerf::ResponseAssertion.new(params)
      attach_node(node, &)
    end
  end

  class ResponseAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "ResponseAssertion" : (params[:name] || "ResponseAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="#{testname}" enabled="true">
          <collectionProp name="Asserion.test_strings">
            <stringProp name="0"/>
          </collectionProp>
          <stringProp name="Assertion.test_field">Assertion.response_data</stringProp>
          <boolProp name="Assertion.assume_success">false</boolProp>
          <intProp name="Assertion.test_type">16</intProp>
          <stringProp name="Assertion.scope">all</stringProp>
        </ResponseAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
