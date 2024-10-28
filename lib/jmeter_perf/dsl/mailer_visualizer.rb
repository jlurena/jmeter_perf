module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element MailerVisualizer
    # @param [Hash] params Parameters for the MailerVisualizer element (default: `{}`).
    # @yield block to attach to the MailerVisualizer element
    # @return [JmeterPerf::MailerVisualizer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#mailervisualizer
    def mailer_visualizer(params = {}, &)
      node = MailerVisualizer.new(params)
      attach_node(node, &)
    end

    class MailerVisualizer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "MailerVisualizer" : (params[:name] || "MailerVisualizer")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <MailerResultCollector guiclass="MailerVisualizer" testclass="MailerResultCollector" testname="#{testname}" enabled="true">
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
              <elementProp name="MailerResultCollector.mailer_model" elementType="MailerModel">
                <stringProp name="MailerModel.successLimit">2</stringProp>
                <stringProp name="MailerModel.failureLimit">2</stringProp>
                <stringProp name="MailerModel.failureSubject"/>
                <stringProp name="MailerModel.fromAddress"/>
                <stringProp name="MailerModel.smtpHost"/>
                <stringProp name="MailerModel.successSubject"/>
                <stringProp name="MailerModel.addressie"/>
              </elementProp>
              <stringProp name="filename"/>
            </MailerResultCollector>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
