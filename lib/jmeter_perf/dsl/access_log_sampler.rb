module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element AccessLogSampler
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#accesslogsampler
    # @param [Hash] params Parameters for the AccessLogSampler element (default: `{}`).
    # @yield block to attach to the AccessLogSampler element
    # @return [JmeterPerf::AccessLogSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def access_log_sampler(params = {}, &)
      node = JmeterPerf::AccessLogSampler.new(params)
      attach_node(node, &)
    end
  end

  class AccessLogSampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "AccessLogSampler" : (params[:name] || "AccessLogSampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
