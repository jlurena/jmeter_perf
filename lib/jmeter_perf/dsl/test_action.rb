module JmeterPerf
  class DSL
    def test_action(params = {}, &)
      node = JmeterPerf::TestAction.new(params)
      attach_node(node, &)
    end
  end

  class TestAction
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "TestAction" : (params[:name] || "TestAction")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <TestAction guiclass="TestActionGui" testclass="TestAction" testname="#{testname}" enabled="true">
          <intProp name="ActionProcessor.action">1</intProp>
          <intProp name="ActionProcessor.target">0</intProp>
          <stringProp name="ActionProcessor.duration"/>
        </TestAction>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
