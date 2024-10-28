module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JDBCPostprocessor
    # @param [Hash] params Parameters for the JDBCPostprocessor element (default: `{}`).
    # @yield block to attach to the JDBCPostprocessor element
    # @return [JmeterPerf::JDBCPostprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jdbcpostprocessor
    def jdbc_postprocessor(params = {}, &)
      node = JDBCPostprocessor.new(params)
      attach_node(node, &)
    end

    class JDBCPostprocessor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JDBCPostprocessor" : (params[:name] || "JDBCPostprocessor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JDBCPostProcessor guiclass="TestBeanGUI" testclass="JDBCPostProcessor" testname="#{testname}" enabled="true">
              <stringProp name="dataSource"/>
              <stringProp name="query"/>
              <stringProp name="queryArguments"/>
              <stringProp name="queryArgumentsTypes"/>
              <stringProp name="queryType">Select Statement</stringProp>
              <stringProp name="resultVariable"/>
              <stringProp name="variableNames"/>
              <stringProp name="queryTimeout"/>
              <stringProp name="resultSetHandler">Store as String</stringProp>
            </JDBCPostProcessor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
