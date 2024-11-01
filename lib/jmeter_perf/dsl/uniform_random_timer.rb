module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element UniformRandomTimer
    # @param params [Hash] Parameters for the UniformRandomTimer element (default: `{}`).
    # @yield block to attach to the UniformRandomTimer element
    # @return [JmeterPerf::UniformRandomTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#uniformrandomtimer
    def uniform_random_timer(params = {}, &)
      node = UniformRandomTimer.new(params)
      attach_node(node, &)
    end

    class UniformRandomTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "UniformRandomTimer" : (params[:name] || "UniformRandomTimer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <UniformRandomTimer guiclass="UniformRandomTimerGui" testclass="UniformRandomTimer" testname="#{testname}" enabled="true">
              <stringProp name="ConstantTimer.delay">0</stringProp>
              <stringProp name="RandomTimer.range">100.0</stringProp>
            </UniformRandomTimer>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
