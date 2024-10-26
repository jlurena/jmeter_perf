module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element DurationAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#durationassertion
    # @param [Hash] params Parameters for the DurationAssertion element (default: `{}`).
    # @yield block to attach to the DurationAssertion element
    # @return [JmeterPerf::DurationAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def duration_assertion(params = {}, &)
      node = JmeterPerf::DurationAssertion.new(params)
      attach_node(node, &)
    end
  end

  class DurationAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "DurationAssertion" : (params[:name] || "DurationAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <DurationAssertion guiclass="DurationAssertionGui" testclass="DurationAssertion" testname="#{testname}" enabled="true">
          <stringProp name="DurationAssertion.duration"/>
        </DurationAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
