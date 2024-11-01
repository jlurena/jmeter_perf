module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RandomController
    # @param params [Hash] Parameters for the RandomController element (default: `{}`).
    # @yield block to attach to the RandomController element
    # @return [JmeterPerf::RandomController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#randomcontroller
    def random_controller(params = {}, &)
      node = RandomController.new(params)
      attach_node(node, &)
    end

    class RandomController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "RandomController" : (params[:name] || "RandomController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <RandomController guiclass="RandomControlGui" testclass="RandomController" testname="#{testname}" enabled="true">
              <intProp name="InterleaveControl.style">1</intProp>
            </RandomController>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
