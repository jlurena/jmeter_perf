module JmeterPerf
  class ExtendedDSL < DSL
    def user_defined_variables(params, &block)
      if params.is_a?(Hash)
        params["Argument.name"] = params[:name]
      end

      super
    end

    alias_method :variables, :user_defined_variables
  end
end
