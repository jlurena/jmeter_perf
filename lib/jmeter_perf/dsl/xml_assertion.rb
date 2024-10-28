module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XMLAssertion
    # @param [Hash] params Parameters for the XMLAssertion element (default: `{}`).
    # @yield block to attach to the XMLAssertion element
    # @return [JmeterPerf::XMLAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xmlassertion
    def xml_assertion(params = {}, &)
      node = XMLAssertion.new(params)
      attach_node(node, &)
    end

    class XMLAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "XMLAssertion" : (params[:name] || "XMLAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <XMLAssertion guiclass="XMLAssertionGui" testclass="XMLAssertion" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
