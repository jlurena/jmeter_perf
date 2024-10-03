module JmeterPerf
  class DSL
    def test_fragment(params={}, &block)
      node = JmeterPerf::TestFragment.new(params)
      attach_node(node, &block)
    end
  end

  class TestFragment
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'TestFragment' : (params[:name] || 'TestFragment')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TestFragmentController guiclass="TestFragmentControllerGui" testclass="TestFragmentController" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
