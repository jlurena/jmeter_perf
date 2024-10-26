module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TestFragment
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#testfragment
    # @param [Hash] params Parameters for the TestFragment element (default: `{}`).
    # @yield block to attach to the TestFragment element
    # @return [JmeterPerf::TestFragment], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def test_fragment(params = {}, &)
      node = JmeterPerf::TestFragment.new(params)
      attach_node(node, &)
    end
  end

  class TestFragment
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "TestFragment" : (params[:name] || "TestFragment")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <TestFragmentController guiclass="TestFragmentControllerGui" testclass="TestFragmentController" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
