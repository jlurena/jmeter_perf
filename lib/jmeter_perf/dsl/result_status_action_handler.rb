module JmeterPerf
  class DSL
    def result_status_action_handler(params = {}, &)
      node = JmeterPerf::ResultStatusActionHandler.new(params)
      attach_node(node, &)
    end
  end

  class ResultStatusActionHandler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "ResultStatusActionHandler" : (params[:name] || "ResultStatusActionHandler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ResultAction guiclass="ResultActionGui" testclass="ResultAction" testname="#{testname}" enabled="true">
          <intProp name="OnError.action">0</intProp>
        </ResultAction>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
