module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element GraphResults
    # @param params [Hash] Parameters for the GraphResults element (default: `{}`).
    # @yield block to attach to the GraphResults element
    # @return [JmeterPerf::GraphResults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#graphresults
    def graph_results(params = {}, &)
      node = GraphResults.new(params)
      attach_node(node, &)
    end

    class GraphResults
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "GraphResults" : (params[:name] || "GraphResults")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ResultCollector guiclass="GraphVisualizer" testclass="ResultCollector" testname="#{testname}" enabled="true">
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
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
