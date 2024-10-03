module JmeterPerf
  class DSL
    def json_path_postprocessor(params={}, &block)
      node = JmeterPerf::JSONPathPostprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class JSONPathPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'JSONPathPostprocessor' : (params[:name] || 'JSONPathPostprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSONPostProcessor guiclass="JSONPostProcessorGui" testclass="JSONPostProcessor" testname="#{testname}" enabled="true">
  <stringProp name="JSONPostProcessor.referenceNames"/>
  <stringProp name="JSONPostProcessor.jsonPathExprs"/>
  <stringProp name="JSONPostProcessor.match_numbers"/>
</JSONPostProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
