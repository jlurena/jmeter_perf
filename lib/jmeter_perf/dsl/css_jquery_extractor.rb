module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element CSSJqueryExtractor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#cssjqueryextractor
    # @param [Hash] params Parameters for the CSSJqueryExtractor element (default: `{}`).
    # @yield block to attach to the CSSJqueryExtractor element
    # @return [JmeterPerf::CSSJqueryExtractor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def css_jquery_extractor(params = {}, &)
      node = JmeterPerf::CSSJqueryExtractor.new(params)
      attach_node(node, &)
    end
  end

  class CSSJqueryExtractor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "CSSJqueryExtractor" : (params[:name] || "CSSJqueryExtractor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
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
