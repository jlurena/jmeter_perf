module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element CompareAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#compareassertion
    # @param [Hash] params Parameters for the CompareAssertion element (default: `{}`).
    # @yield block to attach to the CompareAssertion element
    # @return [JmeterPerf::CompareAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def compare_assertion(params = {}, &)
      node = JmeterPerf::CompareAssertion.new(params)
      attach_node(node, &)
    end
  end

  class CompareAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "CompareAssertion" : (params[:name] || "CompareAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <CompareAssertion guiclass="TestBeanGUI" testclass="CompareAssertion" testname="#{testname}" enabled="true">
          <boolProp name="compareContent">true</boolProp>
          <longProp name="compareTime">-1</longProp>
          <collectionProp name="stringsToSkip"/>
        </CompareAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
