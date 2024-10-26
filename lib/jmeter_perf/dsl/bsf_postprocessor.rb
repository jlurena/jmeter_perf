module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFPostprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfpostprocessor
    # @param [Hash] params Parameters for the BSFPostprocessor element (default: `{}`).
    # @yield block to attach to the BSFPostprocessor element
    # @return [JmeterPerf::BSFPostprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bsf_postprocessor(params = {}, &)
      node = JmeterPerf::BSFPostprocessor.new(params)
      attach_node(node, &)
    end
  end

  class BSFPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFPostprocessor" : (params[:name] || "BSFPostprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFPostProcessor guiclass="TestBeanGUI" testclass="BSFPostProcessor" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFPostProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
