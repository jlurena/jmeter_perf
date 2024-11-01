module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element AccessLogSampler
    # @param params [Hash] Parameters for the AccessLogSampler element (default: `{}`).
    # @yield block to attach to the AccessLogSampler element
    # @return [JmeterPerf::AccessLogSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#accesslogsampler
    def access_log_sampler(params = {}, &)
      node = AccessLogSampler.new(params)
      attach_node(node, &)
    end

    class AccessLogSampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "AccessLogSampler" : (params[:name] || "AccessLogSampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <AccessLogSampler guiclass="TestBeanGUI" testclass="AccessLogSampler" testname="#{testname}" enabled="true">
              <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <stringProp name="domain"/>
              <boolProp name="imageParsing">false</boolProp>
              <stringProp name="logFile"/>
              <stringProp name="parserClassName">org.apache.jmeter.protocol.http.util.accesslog.TCLogParser</stringProp>
              <stringProp name="portString"/>
            </AccessLogSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
