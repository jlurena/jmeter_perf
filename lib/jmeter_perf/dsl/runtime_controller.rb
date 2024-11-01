module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RuntimeController
    # @param params [Hash] Parameters for the RuntimeController element (default: `{}`).
    # @yield block to attach to the RuntimeController element
    # @return [JmeterPerf::RuntimeController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#runtimecontroller
    def runtime_controller(params = {}, &)
      node = RuntimeController.new(params)
      attach_node(node, &)
    end

    class RuntimeController
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "RuntimeController" : (params[:name] || "RuntimeController")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <RunTime guiclass="RunTimeGui" testclass="RunTime" testname="#{testname}" enabled="true">
              <stringProp name="RunTime.seconds">1</stringProp>
            </RunTime>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
