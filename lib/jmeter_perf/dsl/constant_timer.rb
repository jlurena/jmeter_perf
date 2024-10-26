module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ConstantTimer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#constanttimer
    # @param [Hash] params Parameters for the ConstantTimer element (default: `{}`).
    # @yield block to attach to the ConstantTimer element
    # @return [JmeterPerf::ConstantTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def constant_timer(params = {}, &)
      node = JmeterPerf::ConstantTimer.new(params)
      attach_node(node, &)
    end
  end

  class ConstantTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "ConstantTimer" : (params[:name] || "ConstantTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ConstantTimer guiclass="ConstantTimerGui" testclass="ConstantTimer" testname="#{testname}" enabled="true">
          <stringProp name="ConstantTimer.delay">300</stringProp>
        </ConstantTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
