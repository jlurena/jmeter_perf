module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RandomOrderController
    # @param params [Hash] Parameters for the RandomOrderController element (default: `{}`).
    # @yield block to attach to the RandomOrderController element
    # @return [JmeterPerf::RandomOrderController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#randomordercontroller
    def random_order_controller(params = {}, &)
      node = RandomOrderController.new(params)
      attach_node(node, &)
    end

    class RandomOrderController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "RandomOrderController" : (params[:name] || "RandomOrderController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <RandomOrderController guiclass="RandomOrderControllerGui" testclass="RandomOrderController" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
