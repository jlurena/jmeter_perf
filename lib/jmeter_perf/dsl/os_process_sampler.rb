module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element OSProcessSampler
    # @param params [Hash] Parameters for the OSProcessSampler element (default: `{}`).
    # @yield block to attach to the OSProcessSampler element
    # @return [JmeterPerf::OSProcessSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#osprocesssampler
    def os_process_sampler(params = {}, &)
      node = OSProcessSampler.new(params)
      attach_node(node, &)
    end

    class OSProcessSampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "OSProcessSampler" : (params[:name] || "OSProcessSampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <SystemSampler guiclass="SystemSamplerGui" testclass="SystemSampler" testname="#{testname}" enabled="true">
              <boolProp name="SystemSampler.checkReturnCode">false</boolProp>
              <stringProp name="SystemSampler.expectedReturnCode">0</stringProp>
              <stringProp name="SystemSampler.command"/>
              <elementProp name="SystemSampler.arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <elementProp name="SystemSampler.environment" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <stringProp name="SystemSampler.directory"/>
            </SystemSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
