module JmeterPerf
  class ExtendedDSL < DSL
    def random_timer(delay = 0, range = 0, &)
      params = {}
      params[:delay] = delay
      params[:range] = range
      node = JmeterPerf::GaussianRandomTimer.new(params)

      attach_node(node, &)
    end

    alias_method :think_time, :random_timer
  end
end
