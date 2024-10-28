module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTTPHeaderManager
    # @param [Hash] params Parameters for the HTTPHeaderManager element (default: `{}`).
    # @yield block to attach to the HTTPHeaderManager element
    # @return [JmeterPerf::HTTPHeaderManager], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#httpheadermanager
    def http_header_manager(params = {}, &)
      node = HTTPHeaderManager.new(params)
      attach_node(node, &)
    end

    class HTTPHeaderManager
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTTPHeaderManager" : (params[:name] || "HTTPHeaderManager")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="#{testname}" enabled="true">
              <collectionProp name="HeaderManager.headers">
                <elementProp name="" elementType="Header">
                  <stringProp name="Header.name"/>
                  <stringProp name="Header.value"/>
                </elementProp>
              </collectionProp>
            </HeaderManager>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
