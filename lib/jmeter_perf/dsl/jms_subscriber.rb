module JmeterPerf
  class DSL
    def jms_subscriber(params = {}, &)
      node = JmeterPerf::JMSSubscriber.new(params)
      attach_node(node, &)
    end
  end

  class JMSSubscriber
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JMSSubscriber" : (params[:name] || "JMSSubscriber")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <SubscriberSampler guiclass="JMSSubscriberGui" testclass="SubscriberSampler" testname="#{testname}" enabled="true">
          <stringProp name="jms.jndi_properties">false</stringProp>
          <stringProp name="jms.initial_context_factory"/>
          <stringProp name="jms.provider_url"/>
          <stringProp name="jms.connection_factory"/>
          <stringProp name="jms.topic"/>
          <stringProp name="jms.security_principle"/>
          <stringProp name="jms.security_credentials"/>
          <boolProp name="jms.authenticate">false</boolProp>
          <stringProp name="jms.iterations">1</stringProp>
          <stringProp name="jms.read_response">true</stringProp>
          <stringProp name="jms.client_choice">jms_subscriber_receive</stringProp>
        </SubscriberSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
