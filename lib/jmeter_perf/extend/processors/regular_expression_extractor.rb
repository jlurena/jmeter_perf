module JmeterPerf
  class ExtendedDSL < DSL
    def regular_expression_extractor(params, &)
      params[:refname] = params[:name]
      params[:regex] = params[:pattern]
      params[:template] = params[:template] || "$1$"

      node = JmeterPerf::DSL::RegularExpressionExtractor.new(params).tap do |node|
        if params[:variable]
          node.doc.xpath("//stringProp[@name='Sample.scope']").first.content = "variable"

          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
                <stringProp name="Scope.variable">#{params[:variable]}</stringProp>
              EOS
            )).children
          )
        end
      end

      attach_node(node, &)
    end

    alias_method :regex, :regular_expression_extractor
  end
end
