module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JSR223Sampler
    # @param [Hash] params Parameters for the JSR223Sampler element (default: `{}`).
    # @yield block to attach to the JSR223Sampler element
    # @return [JmeterPerf::JSR223Sampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jsr223sampler
    def jsr223_sampler(params = {}, &)
      node = JSR223Sampler.new(params)
      attach_node(node, &)
    end

    class JSR223Sampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JSR223Sampler" : (params[:name] || "JSR223Sampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JSR223Sampler guiclass="TestBeanGUI" testclass="JSR223Sampler" testname="#{testname}" enabled="true">
              <stringProp name="cacheKey"/>
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </JSR223Sampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
