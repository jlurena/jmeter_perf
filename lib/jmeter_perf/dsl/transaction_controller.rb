module JmeterPerf
  class DSL
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
