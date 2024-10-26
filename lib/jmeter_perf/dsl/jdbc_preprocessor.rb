module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JDBCPreprocessor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#jdbcpreprocessor
    # @param [Hash] params Parameters for the JDBCPreprocessor element (default: `{}`).
    # @yield block to attach to the JDBCPreprocessor element
    # @return [JmeterPerf::JDBCPreprocessor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def jdbc_preprocessor(params = {}, &)
      node = JmeterPerf::JDBCPreprocessor.new(params)
      attach_node(node, &)
    end
  end

  class JDBCPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JDBCPreprocessor" : (params[:name] || "JDBCPreprocessor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
