module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ThreadGroup
    # @param params [Hash] Parameters for the ThreadGroup element (default: `{}`).
    # @yield block to attach to the ThreadGroup element
    # @return [JmeterPerf::ThreadGroup], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#threadgroup
    def thread_group(params = {}, &)
      node = ThreadGroup.new(params)
      attach_node(node, &)
    end

    class ThreadGroup
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "ThreadGroup" : (params[:name] || "ThreadGroup")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="#{testname}" enabled="true">
              <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
              <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="#{testname}" enabled="true">
                <boolProp name="LoopController.continue_forever">false</boolProp>
                <intProp name="LoopController.loops">-1</intProp>
              </elementProp>
              <stringProp name="ThreadGroup.num_threads">1</stringProp>
              <stringProp name="ThreadGroup.ramp_time">1</stringProp>
              <longProp name="ThreadGroup.start_time">1366415241000</longProp>
              <longProp name="ThreadGroup.end_time">1366415241000</longProp>
              <boolProp name="ThreadGroup.scheduler">true</boolProp>
              <stringProp name="ThreadGroup.duration"/>
              <stringProp name="ThreadGroup.delay"/>
              <boolProp name="ThreadGroup.delayedStart">true</boolProp>
            </ThreadGroup>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
