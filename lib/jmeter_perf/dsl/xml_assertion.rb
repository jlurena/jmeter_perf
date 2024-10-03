module JmeterPerf
  class DSL
    def xml_assertion(params={}, &block)
      node = JmeterPerf::XMLAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class XMLAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'XMLAssertion' : (params[:name] || 'XMLAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLAssertion guiclass="XMLAssertionGui" testclass="XMLAssertion" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
