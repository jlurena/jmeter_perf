module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JMSPointtoPoint
    # @param params [Hash] Parameters for the JMSPointtoPoint element (default: `{}`).
    # @yield block to attach to the JMSPointtoPoint element
    # @return [JmeterPerf::JMSPointtoPoint], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jmspointtopoint
    def jms_pointto_point(params = {}, &)
      node = JMSPointtoPoint.new(params)
      attach_node(node, &)
    end

    class JMSPointtoPoint
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JMSPointtoPoint" : (params[:name] || "JMSPointtoPoint")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JMSSampler guiclass="JMSSamplerGui" testclass="JMSSampler" testname="#{testname}" enabled="true">
              <stringProp name="JMSSampler.queueconnectionfactory"/>
              <stringProp name="JMSSampler.SendQueue"/>
              <stringProp name="JMSSampler.ReceiveQueue"/>
              <boolProp name="JMSSampler.isFireAndForget">true</boolProp>
              <boolProp name="JMSSampler.isNonPersistent">false</boolProp>
              <boolProp name="JMSSampler.useReqMsgIdAsCorrelId">false</boolProp>
              <boolProp name="JMSSampler.useResMsgIdAsCorrelId">false</boolProp>
              <stringProp name="JMSSampler.timeout"/>
              <stringProp name="HTTPSamper.xml_data"/>
              <stringProp name="JMSSampler.initialContextFactory"/>
              <stringProp name="JMSSampler.contextProviderUrl"/>
              <elementProp name="JMSSampler.jndiProperties" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <elementProp name="arguments" elementType="JMSProperties">
                <collectionProp name="JMSProperties.properties"/>
              </elementProp>
            </JMSSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
