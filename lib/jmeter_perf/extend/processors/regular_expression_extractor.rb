module JmeterPerf
  class ExtendedDSL < DSL
    def regular_expression_extractor(params, &)
      params[:refname] = params[:name]
      params[:regex] = params[:pattern]
      params[:template] = params[:template] || "$1$"

      node = JmeterPerf::RegularExpressionExtractor.new(params).tap do |node|
        if params[:variable]
          node.doc.xpath("//stringProp[@name='Sample.scope']").first.content = "variable"

          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="Scope.variable">#{params[:variable]}</stringProp>
            EOS
          )
        end
      end

      attach_node(node, &)
    end

    alias_method :regex, :regular_expression_extractor
  end
end
