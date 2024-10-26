module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SynchronizingTimer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#synchronizingtimer
    # @param [Hash] params Parameters for the SynchronizingTimer element (default: `{}`).
    # @yield block to attach to the SynchronizingTimer element
    # @return [JmeterPerf::SynchronizingTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def synchronizing_timer(params = {}, &)
      node = JmeterPerf::SynchronizingTimer.new(params)
      attach_node(node, &)
    end
  end

  class SynchronizingTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "SynchronizingTimer" : (params[:name] || "SynchronizingTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <SyncTimer guiclass="TestBeanGUI" testclass="SyncTimer" testname="#{testname}" enabled="true">
          <intProp name="groupSize">0</intProp>
          <longProp name="timeoutInMs">0</longProp>
        </SyncTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
