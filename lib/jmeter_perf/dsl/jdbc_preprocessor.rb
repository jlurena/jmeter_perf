module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JDBCPreprocessor
    # @param [Hash] params Parameters for the JDBCPreprocessor element (default: `{}`).
    # @yield block to attach to the JDBCPreprocessor element
    # @return [JmeterPerf::JDBCPreprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jdbcpreprocessor
    def jdbc_preprocessor(params = {}, &)
      node = JDBCPreprocessor.new(params)
      attach_node(node, &)
    end

    class JDBCPreprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JDBCPreprocessor" : (params[:name] || "JDBCPreprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JDBCPreProcessor guiclass="TestBeanGUI" testclass="JDBCPreProcessor" testname="#{testname}" enabled="true">
              <stringProp name="dataSource"/>
              <stringProp name="query"/>
              <stringProp name="queryArguments"/>
              <stringProp name="queryArgumentsTypes"/>
              <stringProp name="queryType">Select Statement</stringProp>
              <stringProp name="resultVariable"/>
              <stringProp name="variableNames"/>
              <stringProp name="queryTimeout"/>
              <stringProp name="resultSetHandler">Store as String</stringProp>
            </JDBCPreProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
