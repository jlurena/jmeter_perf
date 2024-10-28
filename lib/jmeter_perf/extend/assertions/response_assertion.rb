module JmeterPerf
  class ExtendedDSL < DSL
    def response_assertion(params, &)
      params[:test_type] = parse_test_type(params)
      params["0"] = params.values.first

      if params[:json]
        params[:EXPECTED_VALUE] = params[:value]
        params[:JSON_PATH] = params[:json]
        node = JmeterPerf::Plugins::JsonPathAssertion.new(params)
      end

      node ||= JmeterPerf::DSL::ResponseAssertion.new(params).tap do |node|
        if params[:variable]
          params["Scope.variable"] = params[:variable]
          node.doc.xpath("//stringProp[@name='Assertion.scope']").first.content = "variable"

          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
              <stringProp name="Scope.variable">#{params[:variable]}</stringProp>
              EOS
            )).children
          )
        end

        if params[:scope] == "main"
          node.doc.xpath("//stringProp[@name='Assertion.scope']").remove
        end
      end

      attach_node(node, &)
    end

    alias_method :assert, :response_assertion
    alias_method :web_reg_find, :response_assertion
  end
end
