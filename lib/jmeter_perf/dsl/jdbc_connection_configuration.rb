module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JDBCConnectionConfiguration
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jdbcconnectionconfiguration
    # @param [Hash] params Parameters for the JDBCConnectionConfiguration element (default: `{}`).
    # @yield block to attach to the JDBCConnectionConfiguration element
    # @return [JmeterPerf::JDBCConnectionConfiguration], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def jdbc_connection_configuration(params = {}, &)
      node = JmeterPerf::JDBCConnectionConfiguration.new(params)
      attach_node(node, &)
    end
  end

  class JDBCConnectionConfiguration
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JDBCConnectionConfiguration" : (params[:name] || "JDBCConnectionConfiguration")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
