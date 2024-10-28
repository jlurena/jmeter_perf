module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TransactionController
    # @param [Hash] params Parameters for the TransactionController element (default: `{}`).
    # @yield block to attach to the TransactionController element
    # @return [JmeterPerf::TransactionController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#transactioncontroller
    def transaction_controller(params = {}, &)
      node = TransactionController.new(params)
      attach_node(node, &)
    end

    class TransactionController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "TransactionController" : (params[:name] || "TransactionController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="#{testname}" enabled="true">
              <boolProp name="TransactionController.parent">true</boolProp>
              <boolProp name="TransactionController.includeTimers">false</boolProp>
            </TransactionController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
