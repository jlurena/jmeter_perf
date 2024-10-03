module JmeterPerf
  class DSL
    def x_path_extractor(params={}, &block)
      node = JmeterPerf::XPathExtractor.new(params)
      attach_node(node, &block)
    end
  end

  class XPathExtractor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'XPathExtractor' : (params[:name] || 'XPathExtractor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
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
