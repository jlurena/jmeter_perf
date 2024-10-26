module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element OnceOnlyController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#onceonlycontroller
    # @param [Hash] params Parameters for the OnceOnlyController element (default: `{}`).
    # @yield block to attach to the OnceOnlyController element
    # @return [JmeterPerf::OnceOnlyController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def once_only_controller(params = {}, &)
      node = JmeterPerf::OnceOnlyController.new(params)
      attach_node(node, &)
    end
  end

  class OnceOnlyController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "OnceOnlyController" : (params[:name] || "OnceOnlyController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <OnceOnlyController guiclass="OnceOnlyControllerGui" testclass="OnceOnlyController" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
