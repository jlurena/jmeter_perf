module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XPathExtractor
    # @param params [Hash] Parameters for the XPathExtractor element (default: `{}`).
    # @yield block to attach to the XPathExtractor element
    # @return [JmeterPerf::XPathExtractor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xpathextractor
    def x_path_extractor(params = {}, &)
      node = XPathExtractor.new(params)
      attach_node(node, &)
    end

    class XPathExtractor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "XPathExtractor" : (params[:name] || "XPathExtractor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <XPathExtractor guiclass="XPathExtractorGui" testclass="XPathExtractor" testname="#{testname}" enabled="true">
              <stringProp name="XPathExtractor.default"/>
              <stringProp name="XPathExtractor.refname"/>
              <stringProp name="XPathExtractor.xpathQuery"/>
              <boolProp name="XPathExtractor.validate">false</boolProp>
              <boolProp name="XPathExtractor.tolerant">false</boolProp>
              <boolProp name="XPathExtractor.namespace">false</boolProp>
              <stringProp name="Sample.scope">all</stringProp>
            </XPathExtractor>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
