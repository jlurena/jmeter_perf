module JmeterPerf
  class DSL
    def http_header_manager(params = {}, &)
      node = JmeterPerf::HTTPHeaderManager.new(params)
      attach_node(node, &)
    end
  end

  class HTTPHeaderManager
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "HTTPHeaderManager" : (params[:name] || "HTTPHeaderManager")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="#{testname}" enabled="true">
          <collectionProp name="HeaderManager.headers">
            <elementProp name="" elementType="Header">
              <stringProp name="Header.name"/>
              <stringProp name="Header.value"/>
            </elementProp>
          </collectionProp>
        </HeaderManager>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
