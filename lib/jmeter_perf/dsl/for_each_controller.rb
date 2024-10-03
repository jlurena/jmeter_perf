module JmeterPerf
  class DSL
    def for_each_controller(params={}, &block)
      node = JmeterPerf::ForEachController.new(params)
      attach_node(node, &block)
    end
  end

  class ForEachController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'ForEachController' : (params[:name] || 'ForEachController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ForeachController guiclass="ForeachControlPanel" testclass="ForeachController" testname="#{testname}" enabled="true">
  <stringProp name="ForeachController.inputVal"/>
  <stringProp name="ForeachController.returnVal"/>
  <boolProp name="ForeachController.useSeparator">true</boolProp>
</ForeachController>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
