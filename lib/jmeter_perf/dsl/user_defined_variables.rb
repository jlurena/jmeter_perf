module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element UserDefinedVariables
    # @param params [Hash] Parameters for the UserDefinedVariables element (default: `{}`).
    # @yield block to attach to the UserDefinedVariables element
    # @return [JmeterPerf::UserDefinedVariables], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#userdefinedvariables
    def user_defined_variables(params = {}, &)
      node = UserDefinedVariables.new(params)
      attach_node(node, &)
    end

    class UserDefinedVariables
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "UserDefinedVariables" : (params[:name] || "UserDefinedVariables")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <Arguments guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
              <collectionProp name="Arguments.arguments">
                <elementProp name=" " elementType="Argument">
                  <stringProp name="Argument.name"> </stringProp>
                  <stringProp name="Argument.value"> </stringProp>
                  <stringProp name="Argument.metadata">=</stringProp>
                  <stringProp name="Argument.desc"> </stringProp>
                </elementProp>
              </collectionProp>
              <stringProp name="TestPlan.comments"> </stringProp>
            </Arguments>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
