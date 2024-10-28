module JmeterPerf
  class ExtendedDSL < DSL
    def constant_throughput_timer(params, &)
      params[:value] ||= params[:throughput] || 0.0

      node = JmeterPerf::DSL::ConstantThroughputTimer.new(params)
      node.doc.xpath('//stringProp[@name="throughput"]').first.content = params[:value]
      attach_node(node, &)
    end
  end
end
