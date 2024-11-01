module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element KeystoreConfiguration
    # @param params [Hash] Parameters for the KeystoreConfiguration element (default: `{}`).
    # @yield block to attach to the KeystoreConfiguration element
    # @return [JmeterPerf::KeystoreConfiguration], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#keystoreconfiguration
    def keystore_configuration(params = {}, &)
      node = KeystoreConfiguration.new(params)
      attach_node(node, &)
    end

    class KeystoreConfiguration
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "KeystoreConfiguration" : (params[:name] || "KeystoreConfiguration")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <KeystoreConfig guiclass="TestBeanGUI" testclass="KeystoreConfig" testname="#{testname}" enabled="true">
              <stringProp name="endIndex"/>
              <stringProp name="preload">True</stringProp>
              <stringProp name="startIndex"/>
              <stringProp name="clientCertAliasVarName"/>
            </KeystoreConfig>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
