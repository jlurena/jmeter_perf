module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SimpleConfigElement
    # @param [Hash] params Parameters for the SimpleConfigElement element (default: `{}`).
    # @yield block to attach to the SimpleConfigElement element
    # @return [JmeterPerf::SimpleConfigElement], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#simpleconfigelement
    def simple_config_element(params = {}, &)
      node = SimpleConfigElement.new(params)
      attach_node(node, &)
    end

    class SimpleConfigElement
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "SimpleConfigElement" : (params[:name] || "SimpleConfigElement")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ConfigTestElement guiclass="SimpleConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
