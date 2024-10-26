module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ConstantThroughputTimer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#constantthroughputtimer
    # @param [Hash] params Parameters for the ConstantThroughputTimer element (default: `{}`).
    # @yield block to attach to the ConstantThroughputTimer element
    # @return [JmeterPerf::ConstantThroughputTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def constant_throughput_timer(params = {}, &)
      node = JmeterPerf::ConstantThroughputTimer.new(params)
      attach_node(node, &)
    end
  end

  class ConstantThroughputTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "ConstantThroughputTimer" : (params[:name] || "ConstantThroughputTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ConstantThroughputTimer guiclass="TestBeanGUI" testclass="ConstantThroughputTimer" testname="#{testname}" enabled="true">
          <intProp name="calcMode">0</intProp>
          <stringProp name="throughput">0.0</stringProp>
        </ConstantThroughputTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
