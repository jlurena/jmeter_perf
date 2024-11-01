module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element MailReaderSampler
    # @param params [Hash] Parameters for the MailReaderSampler element (default: `{}`).
    # @yield block to attach to the MailReaderSampler element
    # @return [JmeterPerf::MailReaderSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#mailreadersampler
    def mail_reader_sampler(params = {}, &)
      node = MailReaderSampler.new(params)
      attach_node(node, &)
    end

    class MailReaderSampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "MailReaderSampler" : (params[:name] || "MailReaderSampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <MailReaderSampler guiclass="MailReaderSamplerGui" testclass="MailReaderSampler" testname="#{testname}" enabled="true">
              <stringProp name="host_type">pop3</stringProp>
              <stringProp name="folder">INBOX</stringProp>
              <stringProp name="host"/>
              <stringProp name="username"/>
              <stringProp name="password"/>
              <intProp name="num_messages">-1</intProp>
              <boolProp name="delete">false</boolProp>
              <stringProp name="SMTPSampler.useSSL">false</stringProp>
              <stringProp name="SMTPSampler.useStartTLS">false</stringProp>
              <stringProp name="SMTPSampler.trustAllCerts">false</stringProp>
              <stringProp name="SMTPSampler.enforceStartTLS">false</stringProp>
              <stringProp name="SMTPSampler.useLocalTrustStore">false</stringProp>
              <stringProp name="SMTPSampler.trustStoreToUse"/>
            </MailReaderSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
