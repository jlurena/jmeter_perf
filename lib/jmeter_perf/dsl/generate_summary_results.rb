module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element GenerateSummaryResults
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#generatesummaryresults
    # @param [Hash] params Parameters for the GenerateSummaryResults element (default: `{}`).
    # @yield block to attach to the GenerateSummaryResults element
    # @return [JmeterPerf::GenerateSummaryResults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def generate_summary_results(params = {}, &)
      node = JmeterPerf::GenerateSummaryResults.new(params)
      attach_node(node, &)
    end
  end

  class GenerateSummaryResults
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "GenerateSummaryResults" : (params[:name] || "GenerateSummaryResults")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <Summariser guiclass="SummariserGui" testclass="Summariser" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
