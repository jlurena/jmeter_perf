module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSONPathPostprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsonpathpostprocessor
    # @param [Hash] params Parameters for the JSONPathPostprocessor element (default: `{}`).
    # @yield block to attach to the JSONPathPostprocessor element
    # @return [JmeterPerf::JSONPathPostprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def json_path_postprocessor(params = {}, &)
      node = JmeterPerf::JSONPathPostprocessor.new(params)
      attach_node(node, &)
    end
  end

  class JSONPathPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSONPathPostprocessor" : (params[:name] || "JSONPathPostprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
