module JmeterPerf
  class DSL
    def smtp_sampler(params = {}, &)
      node = JmeterPerf::SMTPSampler.new(params)
      attach_node(node, &)
    end
  end

  class SMTPSampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "SMTPSampler" : (params[:name] || "SMTPSampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <SmtpSampler guiclass="SmtpSamplerGui" testclass="SmtpSampler" testname="#{testname}" enabled="true">
          <stringProp name="SMTPSampler.server"/>
          <stringProp name="SMTPSampler.serverPort"/>
          <stringProp name="SMTPSampler.mailFrom"/>
          <stringProp name="SMTPSampler.replyTo"/>
          <stringProp name="SMTPSampler.receiverTo"/>
          <stringProp name="SMTPSampler.receiverCC"/>
          <stringProp name="SMTPSampler.receiverBCC"/>
          <stringProp name="SMTPSampler.subject"/>
          <stringProp name="SMTPSampler.suppressSubject">false</stringProp>
          <stringProp name="SMTPSampler.include_timestamp">false</stringProp>
          <stringProp name="SMTPSampler.message"/>
          <stringProp name="SMTPSampler.plainBody">false</stringProp>
          <stringProp name="SMTPSampler.attachFile"/>
          <stringProp name="SMTPSampler.useSSL">false</stringProp>
          <stringProp name="SMTPSampler.useStartTLS">false</stringProp>
          <stringProp name="SMTPSampler.trustAllCerts">false</stringProp>
          <stringProp name="SMTPSampler.enforceStartTLS">false</stringProp>
          <stringProp name="SMTPSampler.useLocalTrustStore">false</stringProp>
          <stringProp name="SMTPSampler.trustStoreToUse"/>
          <boolProp name="SMTPSampler.use_eml">false</boolProp>
          <stringProp name="SMTPSampler.emlMessageToSend"/>
          <stringProp name="SMTPSampler.useAuth">false</stringProp>
          <stringProp name="SMTPSampler.password"/>
          <stringProp name="SMTPSampler.username"/>
          <stringProp name="SMTPSampler.messageSizeStatistics">false</stringProp>
          <stringProp name="SMTPSampler.enableDebug">false</stringProp>
          <collectionProp name="SMTPSampler.headerFields"/>
        </SmtpSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
