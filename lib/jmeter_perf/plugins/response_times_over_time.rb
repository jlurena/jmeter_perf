module JmeterPerf
  module Plugins
    class ResponseTimesOverTime
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater
      def initialize(params = {})
        testname = params.is_a?(Array) ? "ResponseTimesOverTime" : (params[:name] || "ResponseTimesOverTime")
        @doc = Nokogiri::XML(
          JmeterPerf::Helpers::String.strip_heredoc(
            <<-EOF
              <kg.apc.jmeter.vizualizers.CorrectedResultCollector guiclass="kg.apc.jmeter.vizualizers.ResponseTimesOverTimeGui" testclass="kg.apc.jmeter.vizualizers.CorrectedResultCollector" testname="#{testname}" enabled="#{enabled(params)}">
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
                    <message>true</message>
                    <threadName>true</threadName>
                    <dataType>true</dataType>
                    <encoding>false</encoding>
                    <assertions>true</assertions>
                    <subresults>true</subresults>
                    <responseData>false</responseData>
                    <samplerData>false</samplerData>
                    <xml>true</xml>
                    <fieldNames>false</fieldNames>
                    <responseHeaders>false</responseHeaders>
                    <requestHeaders>false</requestHeaders>
                    <responseDataOnError>false</responseDataOnError>
                    <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
                    <assertionsResultsToSave>0</assertionsResultsToSave>
                    <bytes>true</bytes>
                  </value>
                </objProp>
                <stringProp name="filename"></stringProp>
                <longProp name="interval_grouping">500</longProp>
                <boolProp name="graph_aggregated">false</boolProp>
                <stringProp name="include_sample_labels"></stringProp>
                <stringProp name="exclude_sample_labels"></stringProp>
              </kg.apc.jmeter.vizualizers.CorrectedResultCollector>
            EOF
          )
        )
        update params
      end
    end
  end
end
