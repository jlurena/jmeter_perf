module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFListener
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsflistener
    # @param [Hash] params Parameters for the BSFListener element (default: `{}`).
    # @yield block to attach to the BSFListener element
    # @return [JmeterPerf::BSFListener], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bsf_listener(params = {}, &)
      node = JmeterPerf::BSFListener.new(params)
      attach_node(node, &)
    end
  end

  class BSFListener
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BSFListener" : (params[:name] || "BSFListener")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BSFListener guiclass="TestBeanGUI" testclass="BSFListener" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </BSFListener>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
