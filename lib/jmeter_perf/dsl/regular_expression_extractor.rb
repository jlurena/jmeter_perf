module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RegularExpressionExtractor
    # @param [Hash] params Parameters for the RegularExpressionExtractor element (default: `{}`).
    # @yield block to attach to the RegularExpressionExtractor element
    # @return [JmeterPerf::RegularExpressionExtractor], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#regularexpressionextractor
    def regular_expression_extractor(params = {}, &)
      node = RegularExpressionExtractor.new(params)
      attach_node(node, &)
    end

    class RegularExpressionExtractor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "RegularExpressionExtractor" : (params[:name] || "RegularExpressionExtractor")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
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
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
