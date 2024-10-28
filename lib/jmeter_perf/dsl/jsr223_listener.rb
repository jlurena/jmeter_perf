module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Listener
    # @param [Hash] params Parameters for the JSR223Listener element (default: `{}`).
    # @yield block to attach to the JSR223Listener element
    # @return [JmeterPerf::JSR223Listener], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223listener
    def jsr223_listener(params = {}, &)
      node = JSR223Listener.new(params)
      attach_node(node, &)
    end

    class JSR223Listener
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JSR223Listener" : (params[:name] || "JSR223Listener")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JSR223Listener guiclass="TestBeanGUI" testclass="JSR223Listener" testname="#{testname}" enabled="true">
              <stringProp name="cacheKey"/>
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </JSR223Listener>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
