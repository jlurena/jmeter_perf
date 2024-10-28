module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element DurationAssertion
    # @param [Hash] params Parameters for the DurationAssertion element (default: `{}`).
    # @yield block to attach to the DurationAssertion element
    # @return [JmeterPerf::DurationAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#durationassertion
    def duration_assertion(params = {}, &)
      node = DurationAssertion.new(params)
      attach_node(node, &)
    end

    class DurationAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "DurationAssertion" : (params[:name] || "DurationAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <DurationAssertion guiclass="DurationAssertionGui" testclass="DurationAssertion" testname="#{testname}" enabled="true">
              <stringProp name="DurationAssertion.duration"/>
            </DurationAssertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
