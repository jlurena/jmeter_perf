module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFTimer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsftimer
    # @param [Hash] params Parameters for the BSFTimer element (default: `{}`).
    # @yield block to attach to the BSFTimer element
    # @return [JmeterPerf::BSFTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bsf_timer(params = {}, &)
      node = JmeterPerf::BSFTimer.new(params)
      attach_node(node, &)
    end
  end

  class BSFTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFTimer" : (params[:name] || "BSFTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFTimer guiclass="TestBeanGUI" testclass="BSFTimer" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
