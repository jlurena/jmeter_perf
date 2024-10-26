module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RegularExpressionExtractor
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#regularexpressionextractor
    # @param [Hash] params Parameters for the RegularExpressionExtractor element (default: `{}`).
    # @yield block to attach to the RegularExpressionExtractor element
    # @return [JmeterPerf::RegularExpressionExtractor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def regular_expression_extractor(params = {}, &)
      node = JmeterPerf::RegularExpressionExtractor.new(params)
      attach_node(node, &)
    end
  end

  class RegularExpressionExtractor
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "RegularExpressionExtractor" : (params[:name] || "RegularExpressionExtractor")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" testname="#{testname}" enabled="true">
          <stringProp name="RegexExtractor.useHeaders">false</stringProp>
          <stringProp name="RegexExtractor.refname"/>
          <stringProp name="RegexExtractor.regex"/>
          <stringProp name="RegexExtractor.template"/>
          <stringProp name="RegexExtractor.default"/>
          <stringProp name="RegexExtractor.match_number"/>
          <stringProp name="Sample.scope">all</stringProp>
          <boolProp name="RegexExtractor.default_empty_value"/>
        </RegexExtractor>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
