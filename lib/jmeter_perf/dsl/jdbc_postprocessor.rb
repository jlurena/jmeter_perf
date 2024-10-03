module JmeterPerf
  class DSL
    def jdbc_postprocessor(params={}, &block)
      node = JmeterPerf::JDBCPostprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class JDBCPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'JDBCPostprocessor' : (params[:name] || 'JDBCPostprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
