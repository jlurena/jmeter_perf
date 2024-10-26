module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element AggregateReport
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#aggregatereport
    # @param [Hash] params Parameters for the AggregateReport element (default: `{}`).
    # @yield block to attach to the AggregateReport element
    # @return [JmeterPerf::AggregateReport], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def aggregate_report(params = {}, &)
      node = JmeterPerf::AggregateReport.new(params)
      attach_node(node, &)
    end
  end

  class AggregateReport
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "AggregateReport" : (params[:name] || "AggregateReport")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ResultCollector guiclass="StatVisualizer" testclass="ResultCollector" testname="#{testname}" enabled="true">
          <boolProp name="ResultCollector.error_logging">false</boolProp>
          <objProp>
            <name>saveConfig</name>
            <value class="SampleSaveConfiguration">
              <time>true</time>
              <latency>true</latency>
              <timestamp>true</timestamp>
              <success>true</success>
              <label>true</label>
              <code>true</code>
              <message>false</message>
              <threadName>true</threadName>
              <dataType>false</dataType>
              <encoding>false</encoding>
              <assertions>false</assertions>
              <subresults>false</subresults>
              <responseData>false</responseData>
              <samplerData>false</samplerData>
              <xml>false</xml>
              <fieldNames>false</fieldNames>
              <responseHeaders>false</responseHeaders>
              <requestHeaders>false</requestHeaders>
              <responseDataOnError>false</responseDataOnError>
              <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
              <assertionsResultsToSave>0</assertionsResultsToSave>
              <bytes>true</bytes>
              <threadCounts>true</threadCounts>
              <sampleCount>true</sampleCount>
            </value>
          </objProp>
          <stringProp name="filename"/>
        </ResultCollector>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
