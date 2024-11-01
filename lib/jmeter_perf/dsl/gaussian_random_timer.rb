module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element GaussianRandomTimer
    # @param params [Hash] Parameters for the GaussianRandomTimer element (default: `{}`).
    # @yield block to attach to the GaussianRandomTimer element
    # @return [JmeterPerf::GaussianRandomTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#gaussianrandomtimer
    def gaussian_random_timer(params = {}, &)
      node = GaussianRandomTimer.new(params)
      attach_node(node, &)
    end

    class GaussianRandomTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "GaussianRandomTimer" : (params[:name] || "GaussianRandomTimer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <GaussianRandomTimer guiclass="GaussianRandomTimerGui" testclass="GaussianRandomTimer" testname="#{testname}" enabled="true">
              <stringProp name="ConstantTimer.delay">300</stringProp>
              <stringProp name="RandomTimer.range">100.0</stringProp>
            </GaussianRandomTimer>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
