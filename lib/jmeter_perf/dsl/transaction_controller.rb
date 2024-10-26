module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element TransactionController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#transactioncontroller
    # @param [Hash] params Parameters for the TransactionController element (default: `{}`).
    # @yield block to attach to the TransactionController element
    # @return [JmeterPerf::TransactionController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def transaction_controller(params = {}, &)
      node = JmeterPerf::TransactionController.new(params)
      attach_node(node, &)
    end
  end

  class TransactionController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "TransactionController" : (params[:name] || "TransactionController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <TransactionController guiclass="TransactionControllerGui" testclass="TransactionController" testname="#{testname}" enabled="true">
          <boolProp name="TransactionController.parent">true</boolProp>
          <boolProp name="TransactionController.includeTimers">false</boolProp>
        </TransactionController>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
