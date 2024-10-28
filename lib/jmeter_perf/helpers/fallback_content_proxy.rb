#
# This module provides a proxy class that delegates method calls to a primary receiver object,
# and falls back to a secondary object if the primary does not respond to the method.
#
# @example
#   primary = PrimaryClass.new
#   fallback = FallbackClass.new
#   proxy = JmeterPerf::Helpers::FallbackContextProxy.new(primary, fallback)
#   proxy.some_method # Will call `some_method` on primary, or fallback if primary does not respond
#
module JmeterPerf::Helpers
  class FallbackContextProxy
    # List of methods that should not be proxied.
    NON_PROXIED_METHODS = [
      :__id__,
      :__send__,
      :!,
      :"!=",
      :==,
      :equal?,
      :instance_eval,
      :instance_variable_get,
      :instance_variable_set,
      :instance_variables,
      :object_id,
      :remove_instance_variable
    ]

    # List of instance variables that should not be proxied.
    NON_PROXIED_INSTANCE_VARIABLES = [
      :@__fallback__,
      :@__receiver__
    ]

    # Initializes a new FallbackContextProxy.
    #
    # @param receiver [Object] the primary object to which method calls are delegated.
    # @param fallback [Object] the secondary object to which method calls are delegated if the primary does not respond.
    def initialize(receiver, fallback)
      @__receiver__ = receiver
      @__fallback__ = fallback
    end

    # Returns the ID of the primary receiver.
    #
    # @return [Object] the ID of the primary receiver.
    def id
      @__receiver__.__send__(:id)
    end

    # Proxies the `sub` method call to the primary receiver or fallback.
    #
    # @param args [Array] the arguments to pass to the `sub` method.
    # @return [Object] the result of the `sub` method call.
    def sub(...)
      __proxy_method__(:sub, ...)
    end

    # Returns the instance variables of the proxy, excluding non-proxied instance variables.
    #
    # @return [Array<Symbol>] the instance variables of the proxy.
    def instance_variables
      super.map(&:to_sym) - NON_PROXIED_INSTANCE_VARIABLES
    end

    # Checks if the proxy responds to a given method.
    #
    # @param name [Symbol] the name of the method.
    # @param include_private [Boolean] whether to include private methods.
    # @return [Boolean] true if the proxy responds to the method, false otherwise.
    def respond_to_missing?(name, include_private)
      __proxy_method__(:respond_to?, name, include_private)
    end

    # Handles method calls that are not explicitly defined in the proxy.
    #
    # @param method [Symbol] the name of the method.
    # @param args [Array] the arguments to pass to the method.
    # @return [Object] the result of the method call.
    def method_missing(method, ...)
      __proxy_method__(method, ...)
    end

    # Proxies a method call to the primary receiver or fallback.
    #
    # @param method [Symbol] the name of the method.
    # @param args [Array] the arguments to pass to the method.
    # @return [Object] the result of the method call.
    # @raise [NoMethodError] if neither the primary receiver nor the fallback respond to the method.
    def __proxy_method__(method, ...)
      @__receiver__.__send__(method.to_sym, ...)
    rescue NoMethodError
      @__fallback__.__send__(method.to_sym, ...)
    end
  end
end
