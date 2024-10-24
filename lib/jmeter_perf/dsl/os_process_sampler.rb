module JmeterPerf
  class DSL
    def os_process_sampler(params = {}, &)
      node = JmeterPerf::OSProcessSampler.new(params)
      attach_node(node, &)
    end
  end

  class OSProcessSampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "OSProcessSampler" : (params[:name] || "OSProcessSampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <SystemSampler guiclass="SystemSamplerGui" testclass="SystemSampler" testname="#{testname}" enabled="true">
          <boolProp name="SystemSampler.checkReturnCode">false</boolProp>
          <stringProp name="SystemSampler.expectedReturnCode">0</stringProp>
          <stringProp name="SystemSampler.command"/>
          <elementProp name="SystemSampler.arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
            <collectionProp name="Arguments.arguments"/>
          </elementProp>
          <elementProp name="SystemSampler.environment" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
            <collectionProp name="Arguments.arguments"/>
          </elementProp>
          <stringProp name="SystemSampler.directory"/>
        </SystemSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
