module JmeterPerf
  class DSL
    def css_jquery_extractor(params={}, &block)
      node = JmeterPerf::CSS_JqueryExtractor.new(params)
      attach_node(node, &block)
    end
  end

  class CSS_JqueryExtractor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'CSS_JqueryExtractor' : (params[:name] || 'CSS_JqueryExtractor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HtmlExtractor guiclass="HtmlExtractorGui" testclass="HtmlExtractor" testname="#{testname}" enabled="true">
  <stringProp name="HtmlExtractor.refname"/>
  <stringProp name="HtmlExtractor.expr"/>
  <stringProp name="HtmlExtractor.attribute"/>
  <stringProp name="HtmlExtractor.default"/>
  <stringProp name="HtmlExtractor.match_number"/>
  <stringProp name="HtmlExtractor.extractor_impl"/>
  <boolProp name="HtmlExtractor.default_empty_value"/>
</HtmlExtractor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
