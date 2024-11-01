module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TestAction
    # @param params [Hash] Parameters for the TestAction element (default: `{}`).
    # @yield block to attach to the TestAction element
    # @return [JmeterPerf::TestAction], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#testaction
    def test_action(params = {}, &)
      node = TestAction.new(params)
      attach_node(node, &)
    end

    class TestAction
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "TestAction" : (params[:name] || "TestAction")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <TestAction guiclass="TestActionGui" testclass="TestAction" testname="#{testname}" enabled="true">
              <intProp name="ActionProcessor.action">1</intProp>
              <intProp name="ActionProcessor.target">0</intProp>
              <stringProp name="ActionProcessor.duration"/>
            </TestAction>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
