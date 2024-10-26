module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element MonitorResults
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#monitorresults
    # @param [Hash] params Parameters for the MonitorResults element (default: `{}`).
    # @yield block to attach to the MonitorResults element
    # @return [JmeterPerf::MonitorResults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def monitor_results(params = {}, &)
      node = JmeterPerf::MonitorResults.new(params)
      attach_node(node, &)
    end
  end

  class MonitorResults
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "MonitorResults" : (params[:name] || "MonitorResults")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ResultCollector guiclass="MonitorHealthVisualizer" testclass="ResultCollector" testname="#{testname}" enabled="true">
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
