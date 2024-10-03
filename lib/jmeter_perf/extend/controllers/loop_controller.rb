module JmeterPerf
  class ExtendedDSL < DSL
    def loop_controller(params, &block)
      params[:loops] = params[:count] || 1

      super
    end

    alias_method :loops, :loop_controller
  end
end
