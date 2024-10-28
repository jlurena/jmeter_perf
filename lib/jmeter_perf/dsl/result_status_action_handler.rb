module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ResultStatusActionHandler
    # @param [Hash] params Parameters for the ResultStatusActionHandler element (default: `{}`).
    # @yield block to attach to the ResultStatusActionHandler element
    # @return [JmeterPerf::ResultStatusActionHandler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#resultstatusactionhandler
    def result_status_action_handler(params = {}, &)
      node = ResultStatusActionHandler.new(params)
      attach_node(node, &)
    end

    class ResultStatusActionHandler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "ResultStatusActionHandler" : (params[:name] || "ResultStatusActionHandler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ResultAction guiclass="ResultActionGui" testclass="ResultAction" testname="#{testname}" enabled="true">
              <intProp name="OnError.action">0</intProp>
            </ResultAction>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
