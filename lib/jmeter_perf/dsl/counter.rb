module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element Counter
    # @param [Hash] params Parameters for the Counter element (default: `{}`).
    # @yield block to attach to the Counter element
    # @return [JmeterPerf::Counter], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#counter
    def counter(params = {}, &)
      node = Counter.new(params)
      attach_node(node, &)
    end

    class Counter
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "Counter" : (params[:name] || "Counter")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <CounterConfig guiclass="CounterConfigGui" testclass="CounterConfig" testname="#{testname}" enabled="true">
              <stringProp name="CounterConfig.start"/>
              <stringProp name="CounterConfig.end"/>
              <stringProp name="CounterConfig.incr"/>
              <stringProp name="CounterConfig.name"/>
              <stringProp name="CounterConfig.format"/>
              <boolProp name="CounterConfig.per_user">true</boolProp>
              <boolProp name="CounterConfig.reset_on_tg_iteration">true</boolProp>
            </CounterConfig>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
