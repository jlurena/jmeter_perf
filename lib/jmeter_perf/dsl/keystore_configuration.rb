module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element KeystoreConfiguration
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#keystoreconfiguration
    # @param [Hash] params Parameters for the KeystoreConfiguration element (default: `{}`).
    # @yield block to attach to the KeystoreConfiguration element
    # @return [JmeterPerf::KeystoreConfiguration], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def keystore_configuration(params = {}, &)
      node = JmeterPerf::KeystoreConfiguration.new(params)
      attach_node(node, &)
    end
  end

  class KeystoreConfiguration
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "KeystoreConfiguration" : (params[:name] || "KeystoreConfiguration")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <KeystoreConfig guiclass="TestBeanGUI" testclass="KeystoreConfig" testname="#{testname}" enabled="true">
          <stringProp name="endIndex"/>
          <stringProp name="preload">True</stringProp>
          <stringProp name="startIndex"/>
          <stringProp name="clientCertAliasVarName"/>
        </KeystoreConfig>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
