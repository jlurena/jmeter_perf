module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element UserParameters
    # @param params [Hash] Parameters for the UserParameters element (default: `{}`).
    # @yield block to attach to the UserParameters element
    # @return [JmeterPerf::UserParameters], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#userparameters
    def user_parameters(params = {}, &)
      node = UserParameters.new(params)
      attach_node(node, &)
    end

    class UserParameters
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "UserParameters" : (params[:name] || "UserParameters")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <UserParameters guiclass="UserParametersGui" testclass="UserParameters" testname="#{testname}" enabled="true">
              <collectionProp name="UserParameters.names"/>
              <collectionProp name="UserParameters.thread_values">
                <collectionProp name="1"/>
                <collectionProp name="1"/>
              </collectionProp>
              <boolProp name="UserParameters.per_iteration">false</boolProp>
            </UserParameters>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
