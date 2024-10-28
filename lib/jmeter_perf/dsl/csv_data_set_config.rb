module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element CSVDataSetConfig
    # @param [Hash] params Parameters for the CSVDataSetConfig element (default: `{}`).
    # @yield block to attach to the CSVDataSetConfig element
    # @return [JmeterPerf::CSVDataSetConfig], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#csvdatasetconfig
    def csv_data_set_config(params = {}, &)
      node = CSVDataSetConfig.new(params)
      attach_node(node, &)
    end

    class CSVDataSetConfig
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "CSVDataSetConfig" : (params[:name] || "CSVDataSetConfig")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
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
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
