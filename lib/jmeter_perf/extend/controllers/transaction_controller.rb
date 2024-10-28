module JmeterPerf
  class ExtendedDSL < DSL
    def transaction_controller(*args, &)
      params = args.shift || {}
      params = {name: params}.merge(args.shift || {}) if params.is_a?(String)
      params[:parent] = params[:parent] || false
      params[:includeTimers] = params[:include_timers] || false
      node = JmeterPerf::DSL::TransactionController.new(params)
      attach_node(node, &)
    end

    alias_method :transaction, :transaction_controller
  end
end
