module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellListener
    # @param params [Hash] Parameters for the BeanShellListener element (default: `{}`).
    # @yield block to attach to the BeanShellListener element
    # @return [JmeterPerf::BeanShellListener], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshelllistener
    def bean_shell_listener(params = {}, &)
      node = BeanShellListener.new(params)
      attach_node(node, &)
    end

    class BeanShellListener
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BeanShellListener" : (params[:name] || "BeanShellListener")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BeanShellListener guiclass="TestBeanGUI" testclass="BeanShellListener" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <boolProp name="resetInterpreter">false</boolProp>
              <stringProp name="script"/>
            </BeanShellListener>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
