module JmeterPerf
  class DSL
    def csv_data_set_config(params = {}, &)
      node = JmeterPerf::CSVDataSetConfig.new(params)
      attach_node(node, &)
    end
  end

  class CSVDataSetConfig
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "CSVDataSetConfig" : (params[:name] || "CSVDataSetConfig")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <CSVDataSet guiclass="TestBeanGUI" testclass="CSVDataSet" testname="#{testname}" enabled="true">
          <stringProp name="delimiter">,</stringProp>
          <stringProp name="fileEncoding"/>
          <stringProp name="filename"/>
          <boolProp name="quotedData">false</boolProp>
          <boolProp name="recycle">true</boolProp>
          <stringProp name="shareMode">shareMode.all</stringProp>
          <boolProp name="stopThread">false</boolProp>
          <boolProp name="ignoreFirstLine">false</boolProp>
          <stringProp name="variableNames"/>
        </CSVDataSet>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
