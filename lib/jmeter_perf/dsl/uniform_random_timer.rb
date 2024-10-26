module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element UniformRandomTimer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#uniformrandomtimer
    # @param [Hash] params Parameters for the UniformRandomTimer element (default: `{}`).
    # @yield block to attach to the UniformRandomTimer element
    # @return [JmeterPerf::UniformRandomTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def uniform_random_timer(params = {}, &)
      node = JmeterPerf::UniformRandomTimer.new(params)
      attach_node(node, &)
    end
  end

  class UniformRandomTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "UniformRandomTimer" : (params[:name] || "UniformRandomTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <UniformRandomTimer guiclass="UniformRandomTimerGui" testclass="UniformRandomTimer" testname="#{testname}" enabled="true">
          <stringProp name="ConstantTimer.delay">0</stringProp>
          <stringProp name="RandomTimer.range">100.0</stringProp>
        </UniformRandomTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
