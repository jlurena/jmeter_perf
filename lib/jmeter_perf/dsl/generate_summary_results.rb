module JmeterPerf
  class DSL
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
