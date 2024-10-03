module JmeterPerf
  class ExtendedDSL < DSL
    def soapxmlrpc_request(params, &block)
      params[:method] ||= "POST"

      super
    end
    alias_method :soap, :soapxmlrpc_request
  end
end
