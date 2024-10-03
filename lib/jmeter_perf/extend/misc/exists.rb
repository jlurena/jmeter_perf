module JmeterPerf
  class ExtendedDSL < DSL
    def exists(variable, &)
      params ||= {}
      params[:condition] = "\"${#{variable}}\" != \"\\${#{variable}}\""
      params[:useExpression] = false
      params[:name] = "if ${#{variable}}"
      node = JmeterPerf::IfController.new(params)

      attach_node(node, &)
    end
  end
end
