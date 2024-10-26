module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SMIMEAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#smimeassertion
    # @param [Hash] params Parameters for the SMIMEAssertion element (default: `{}`).
    # @yield block to attach to the SMIMEAssertion element
    # @return [JmeterPerf::SMIMEAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def smime_assertion(params = {}, &)
      node = JmeterPerf::SMIMEAssertion.new(params)
      attach_node(node, &)
    end
  end

  class SMIMEAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "SMIMEAssertion" : (params[:name] || "SMIMEAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
