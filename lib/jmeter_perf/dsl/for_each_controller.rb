module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element ForEachController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#foreachcontroller
    # @param [Hash] params Parameters for the ForEachController element (default: `{}`).
    # @yield block to attach to the ForEachController element
    # @return [JmeterPerf::ForEachController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def for_each_controller(params = {}, &)
      node = JmeterPerf::ForEachController.new(params)
      attach_node(node, &)
    end
  end

  class ForEachController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "ForEachController" : (params[:name] || "ForEachController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ForeachController guiclass="ForeachControlPanel" testclass="ForeachController" testname="#{testname}" enabled="true">
          <stringProp name="ForeachController.inputVal"/>
          <stringProp name="ForeachController.returnVal"/>
          <boolProp name="ForeachController.useSeparator">true</boolProp>
        </ForeachController>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
