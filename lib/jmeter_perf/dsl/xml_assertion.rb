module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XMLAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xmlassertion
    # @param [Hash] params Parameters for the XMLAssertion element (default: `{}`).
    # @yield block to attach to the XMLAssertion element
    # @return [JmeterPerf::XMLAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def xml_assertion(params = {}, &)
      node = JmeterPerf::XMLAssertion.new(params)
      attach_node(node, &)
    end
  end

  class XMLAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "XMLAssertion" : (params[:name] || "XMLAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <XMLAssertion guiclass="XMLAssertionGui" testclass="XMLAssertion" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
