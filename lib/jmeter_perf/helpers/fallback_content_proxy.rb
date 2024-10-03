module JmeterPerf
  class FallbackContextProxy
    NON_PROXIED_METHODS = Set[:object_id, :__send__, :__id__, :==, :equal?, :!, :"!=", :instance_eval,
      :instance_variables, :instance_variable_get, :instance_variable_set,
      :remove_instance_variable]

    NON_PROXIED_INSTANCE_VARIABLES = Set[:@__receiver__, :@__fallback__]

    instance_methods.each do |method|
      unless NON_PROXIED_METHODS.include?(method.to_sym)
        undef_method(method)
      end
    end

    def initialize(receiver, fallback)
      @__receiver__ = receiver
      @__fallback__ = fallback
    end

    def id
      @__receiver__.__send__(:id)
    end

    # Special case due to `Kernel#sub`'s existence
    def sub(...)
      __proxy_method__(:sub, ...)
    end

    # Special case to allow proxy instance variables
    def instance_variables
      super.map(&:to_sym) - NON_PROXIED_INSTANCE_VARIABLES.to_a
    end

    def respond_to_missing?(name, include_private)
      __proxy_method__(:respond_to?, name, include_private)
    end

    def method_missing(method, ...)
      __proxy_method__(method, ...)
    end

    def __proxy_method__(method, ...)
      @__receiver__.__send__(method.to_sym, ...)
    rescue ::NoMethodError => e
      begin
        @__fallback__.__send__(method.to_sym, ...)
      rescue ::NoMethodError
        raise(e)
      end
    end
  end
end
