module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element XPathExtractor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#xpathextractor
    # @param [Hash] params Parameters for the XPathExtractor element (default: `{}`).
    # @yield block to attach to the XPathExtractor element
    # @return [JmeterPerf::XPathExtractor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def x_path_extractor(params = {}, &)
      node = JmeterPerf::XPathExtractor.new(params)
      attach_node(node, &)
    end
  end

  class XPathExtractor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "XPathExtractor" : (params[:name] || "XPathExtractor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
