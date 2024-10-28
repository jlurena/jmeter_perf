module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JDBCConnectionConfiguration
    # @param [Hash] params Parameters for the JDBCConnectionConfiguration element (default: `{}`).
    # @yield block to attach to the JDBCConnectionConfiguration element
    # @return [JmeterPerf::JDBCConnectionConfiguration], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jdbcconnectionconfiguration
    def jdbc_connection_configuration(params = {}, &)
      node = JDBCConnectionConfiguration.new(params)
      attach_node(node, &)
    end

    class JDBCConnectionConfiguration
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JDBCConnectionConfiguration" : (params[:name] || "JDBCConnectionConfiguration")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JDBCDataSource guiclass="TestBeanGUI" testclass="JDBCDataSource" testname="#{testname}" enabled="true">
              <boolProp name="autocommit">true</boolProp>
              <stringProp name="checkQuery">Select 1</stringProp>
              <stringProp name="connectionAge">5000</stringProp>
              <stringProp name="dataSource"/>
              <stringProp name="dbUrl"/>
              <stringProp name="driver"/>
              <boolProp name="keepAlive">true</boolProp>
              <stringProp name="password"/>
              <stringProp name="poolMax">10</stringProp>
              <stringProp name="timeout">10000</stringProp>
              <stringProp name="transactionIsolation">DEFAULT</stringProp>
              <stringProp name="trimInterval">60000</stringProp>
              <stringProp name="username"/>
            </JDBCDataSource>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
