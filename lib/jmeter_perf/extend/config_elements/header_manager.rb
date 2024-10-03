module JmeterPerf
  class ExtendedDSL < DSL
    def http_header_manager(params, &block)
      if params.is_a?(Hash)
        params["Header.name"] = params[:name]
      end

      super
    end

    alias_method :header, :http_header_manager
  end
end
