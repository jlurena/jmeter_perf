module JmeterPerf
  class DSL
    def distribution_graph_alpha_(params={}, &block)
      node = JmeterPerf::DistributionGraph_alpha_.new(params)
      attach_node(node, &block)
    end
  end

  class DistributionGraph_alpha_
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'DistributionGraph_alpha_' : (params[:name] || 'DistributionGraph_alpha_')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResultCollector guiclass="DistributionGraphVisualizer" testclass="ResultCollector" testname="#{testname}" enabled="true">
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
