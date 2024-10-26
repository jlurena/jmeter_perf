module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFPreprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfpreprocessor
    # @param [Hash] params Parameters for the BSFPreprocessor element (default: `{}`).
    # @yield block to attach to the BSFPreprocessor element
    # @return [JmeterPerf::BSFPreprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bsf_preprocessor(params = {}, &)
      node = JmeterPerf::BSFPreprocessor.new(params)
      attach_node(node, &)
    end
  end

  class BSFPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFPreprocessor" : (params[:name] || "BSFPreprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFPreProcessor guiclass="TestBeanGUI" testclass="BSFPreProcessor" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFPreProcessor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
