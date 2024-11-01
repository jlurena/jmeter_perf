module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JDBCRequest
    # @param params [Hash] Parameters for the JDBCRequest element (default: `{}`).
    # @yield block to attach to the JDBCRequest element
    # @return [JmeterPerf::JDBCRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jdbcrequest
    def jdbc_request(params = {}, &)
      node = JDBCRequest.new(params)
      attach_node(node, &)
    end

    class JDBCRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JDBCRequest" : (params[:name] || "JDBCRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JDBCSampler guiclass="TestBeanGUI" testclass="JDBCSampler" testname="#{testname}" enabled="true">
              <stringProp name="dataSource"/>
              <stringProp name="query"/>
              <stringProp name="queryArguments"/>
              <stringProp name="queryArgumentsTypes"/>
              <stringProp name="queryType">Select Statement</stringProp>
              <stringProp name="resultVariable"/>
              <stringProp name="variableNames"/>
              <stringProp name="queryTimeout"/>
              <stringProp name="resultSetHandler">Store as String</stringProp>
            </JDBCSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
