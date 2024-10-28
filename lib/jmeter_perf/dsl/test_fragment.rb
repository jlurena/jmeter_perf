module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TestFragment
    # @param [Hash] params Parameters for the TestFragment element (default: `{}`).
    # @yield block to attach to the TestFragment element
    # @return [JmeterPerf::TestFragment], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#testfragment
    def test_fragment(params = {}, &)
      node = TestFragment.new(params)
      attach_node(node, &)
    end

    class TestFragment
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "TestFragment" : (params[:name] || "TestFragment")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <TestFragmentController guiclass="TestFragmentControllerGui" testclass="TestFragmentController" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
