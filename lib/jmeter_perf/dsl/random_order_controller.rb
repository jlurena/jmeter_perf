module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RandomOrderController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#randomordercontroller
    # @param [Hash] params Parameters for the RandomOrderController element (default: `{}`).
    # @yield block to attach to the RandomOrderController element
    # @return [JmeterPerf::RandomOrderController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def random_order_controller(params = {}, &)
      node = JmeterPerf::RandomOrderController.new(params)
      attach_node(node, &)
    end
  end

  class RandomOrderController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "RandomOrderController" : (params[:name] || "RandomOrderController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <RandomOrderController guiclass="RandomOrderControllerGui" testclass="RandomOrderController" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
