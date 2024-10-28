module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element GenerateSummaryResults
    # @param [Hash] params Parameters for the GenerateSummaryResults element (default: `{}`).
    # @yield block to attach to the GenerateSummaryResults element
    # @return [JmeterPerf::GenerateSummaryResults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#generatesummaryresults
    def generate_summary_results(params = {}, &)
      node = GenerateSummaryResults.new(params)
      attach_node(node, &)
    end

    class GenerateSummaryResults
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "GenerateSummaryResults" : (params[:name] || "GenerateSummaryResults")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <Summariser guiclass="SummariserGui" testclass="Summariser" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
