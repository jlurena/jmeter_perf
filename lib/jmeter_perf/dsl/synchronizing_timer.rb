module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SynchronizingTimer
    # @param params [Hash] Parameters for the SynchronizingTimer element (default: `{}`).
    # @yield block to attach to the SynchronizingTimer element
    # @return [JmeterPerf::SynchronizingTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#synchronizingtimer
    def synchronizing_timer(params = {}, &)
      node = SynchronizingTimer.new(params)
      attach_node(node, &)
    end

    class SynchronizingTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "SynchronizingTimer" : (params[:name] || "SynchronizingTimer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <SyncTimer guiclass="TestBeanGUI" testclass="SyncTimer" testname="#{testname}" enabled="true">
              <intProp name="groupSize">0</intProp>
              <longProp name="timeoutInMs">0</longProp>
            </SyncTimer>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
