module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SwitchController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#switchcontroller
    # @param [Hash] params Parameters for the SwitchController element (default: `{}`).
    # @yield block to attach to the SwitchController element
    # @return [JmeterPerf::SwitchController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def switch_controller(params = {}, &)
      node = JmeterPerf::SwitchController.new(params)
      attach_node(node, &)
    end
  end

  class SwitchController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "SwitchController" : (params[:name] || "SwitchController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <SwitchController guiclass="SwitchControllerGui" testclass="SwitchController" testname="#{testname}" enabled="true">
          <stringProp name="SwitchController.value"/>
        </SwitchController>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
