module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfassertion
    # @param [Hash] params Parameters for the BSFAssertion element (default: `{}`).
    # @yield block to attach to the BSFAssertion element
    # @return [JmeterPerf::BSFAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bsf_assertion(params = {}, &)
      node = JmeterPerf::BSFAssertion.new(params)
      attach_node(node, &)
    end
  end

  class BSFAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFAssertion" : (params[:name] || "BSFAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFAssertion guiclass="TestBeanGUI" testclass="BSFAssertion" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
