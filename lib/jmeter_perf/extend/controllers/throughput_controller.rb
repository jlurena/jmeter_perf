module JmeterPerf
  class ExtendedDSL < DSL
    def throughput_controller(params = {}, &)
      params[:style] = 1 if params[:percent]
      params[:maxThroughput] = params[:total] || params[:percent] || 1

      node = JmeterPerf::ThroughputController.new(params)
      node.doc.xpath(".//FloatProperty/value").first.content = params[:maxThroughput].to_f

      attach_node(node, &)
    end

    alias_method :throughput, :throughput_controller
  end
end
