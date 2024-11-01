module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SMIMEAssertion
    # @param params [Hash] Parameters for the SMIMEAssertion element (default: `{}`).
    # @yield block to attach to the SMIMEAssertion element
    # @return [JmeterPerf::SMIMEAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#smimeassertion
    def smime_assertion(params = {}, &)
      node = SMIMEAssertion.new(params)
      attach_node(node, &)
    end

    class SMIMEAssertion
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "SMIMEAssertion" : (params[:name] || "SMIMEAssertion")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <SMIMEAssertion guiclass="SMIMEAssertionGui" testclass="SMIMEAssertion" testname="#{testname}" enabled="true">
              <boolProp name="SMIMEAssert.verifySignature">false</boolProp>
              <boolProp name="SMIMEAssert.notSigned">false</boolProp>
              <stringProp name="SMIMEAssert.issuerDn"/>
              <stringProp name="SMIMEAssert.signerDn"/>
              <stringProp name="SMIMEAssert.signerSerial"/>
              <stringProp name="SMIMEAssert.signerEmail"/>
              <stringProp name="SMIMEAssert.signerCertFile"/>
              <boolProp name="SMIMEAssert.signerNoCheck">false</boolProp>
              <boolProp name="SMIMEAssert.signerCheckConstraints">false</boolProp>
              <boolProp name="SMIMEAssert.signerCheckByFile">false</boolProp>
              <stringProp name="SMIMEAssert.messagePosition"/>
            </SMIMEAssertion>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
