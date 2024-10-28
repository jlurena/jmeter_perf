module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ConstantTimer
    # @param [Hash] params Parameters for the ConstantTimer element (default: `{}`).
    # @yield block to attach to the ConstantTimer element
    # @return [JmeterPerf::ConstantTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#constanttimer
    def constant_timer(params = {}, &)
      node = ConstantTimer.new(params)
      attach_node(node, &)
    end

    class ConstantTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "ConstantTimer" : (params[:name] || "ConstantTimer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConstantTimer guiclass="ConstantTimerGui" testclass="ConstantTimer" testname="#{testname}" enabled="true">
              <stringProp name="ConstantTimer.delay">300</stringProp>
            </ConstantTimer>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
