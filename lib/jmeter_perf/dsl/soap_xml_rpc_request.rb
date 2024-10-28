module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SOAPXmlRPCRequest
    # @param [Hash] params Parameters for the SOAPXmlRPCRequest element (default: `{}`).
    # @yield block to attach to the SOAPXmlRPCRequest element
    # @return [JmeterPerf::SOAPXmlRPCRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#soapxmlrpcrequest
    def soap_xml_rpc_request(params = {}, &)
      node = SOAPXmlRPCRequest.new(params)
      attach_node(node, &)
    end

    class SOAPXmlRPCRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "SOAPXmlRPCRequest" : (params[:name] || "SOAPXmlRPCRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <SoapSampler guiclass="SoapSamplerGui" testclass="SoapSampler" testname="#{testname}" enabled="true">
              <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
                <collectionProp name="Arguments.arguments"/>
              </elementProp>
              <stringProp name="SoapSampler.URL_DATA"/>
              <stringProp name="HTTPSamper.xml_data"/>
              <stringProp name="SoapSampler.xml_data_file"/>
              <stringProp name="SoapSampler.SOAP_ACTION"/>
              <stringProp name="SoapSampler.SEND_SOAP_ACTION">true</stringProp>
              <boolProp name="HTTPSampler.use_keepalive">false</boolProp>
            </SoapSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
