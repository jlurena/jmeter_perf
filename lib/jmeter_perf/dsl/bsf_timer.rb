module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFTimer
    # @param params [Hash] Parameters for the BSFTimer element (default: `{}`).
    # @yield block to attach to the BSFTimer element
    # @return [JmeterPerf::BSFTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsftimer
    def bsf_timer(params = {}, &)
      node = BSFTimer.new(params)
      attach_node(node, &)
    end

    class BSFTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BSFTimer" : (params[:name] || "BSFTimer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BSFTimer guiclass="TestBeanGUI" testclass="BSFTimer" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </BSFTimer>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
