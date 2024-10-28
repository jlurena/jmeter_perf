module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element PoissonRandomTimer
    # @param [Hash] params Parameters for the PoissonRandomTimer element (default: `{}`).
    # @yield block to attach to the PoissonRandomTimer element
    # @return [JmeterPerf::PoissonRandomTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#poissonrandomtimer
    def poisson_random_timer(params = {}, &)
      node = PoissonRandomTimer.new(params)
      attach_node(node, &)
    end

    class PoissonRandomTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "PoissonRandomTimer" : (params[:name] || "PoissonRandomTimer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <PoissonRandomTimer guiclass="PoissonRandomTimerGui" testclass="PoissonRandomTimer" testname="#{testname}" enabled="true">
              <stringProp name="ConstantTimer.delay">300</stringProp>
              <stringProp name="RandomTimer.range">100</stringProp>
            </PoissonRandomTimer>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
