module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFSampler
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfsampler
    # @param [Hash] params Parameters for the BSFSampler element (default: `{}`).
    # @yield block to attach to the BSFSampler element
    # @return [JmeterPerf::BSFSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bsf_sampler(params = {}, &)
      node = JmeterPerf::BSFSampler.new(params)
      attach_node(node, &)
    end
  end

  class BSFSampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFSampler" : (params[:name] || "BSFSampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFSampler guiclass="TestBeanGUI" testclass="BSFSampler" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
