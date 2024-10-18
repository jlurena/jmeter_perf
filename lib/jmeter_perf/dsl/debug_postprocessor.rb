module JmeterPerf
  class DSL
    def debug_postprocessor(params = {}, &)
      node = JmeterPerf::DebugPostprocessor.new(params)
      attach_node(node, &)
    end
  end

  class DebugPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "DebugPostprocessor" : (params[:name] || "DebugPostprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <DebugPostProcessor guiclass="TestBeanGUI" testclass="DebugPostProcessor" testname="#{testname}" enabled="true">
          <boolProp name="displayJMeterProperties">false</boolProp>
          <boolProp name="displayJMeterVariables">true</boolProp>
          <boolProp name="displaySamplerProperties">true</boolProp>
          <boolProp name="displaySystemProperties">false</boolProp>
        </DebugPostProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
