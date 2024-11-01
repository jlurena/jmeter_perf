module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TestPlan
    # @param params [Hash] Parameters for the TestPlan element (default: `{}`).
    # @yield block to attach to the TestPlan element
    # @return [JmeterPerf::TestPlan], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#testplan
    def test_plan(params = {}, &)
      node = TestPlan.new(params)
      attach_node(node, &)
    end

    class TestPlan
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "TestPlan" : (params[:name] || "TestPlan")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="#{testname}" enabled="true">
              <stringProp name="TestPlan.comments"/>
              <boolProp name="TestPlan.functional_mode">false</boolProp>
              <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
              <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <stringProp name="TestPlan.user_define_classpath"/>
            </TestPlan>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
