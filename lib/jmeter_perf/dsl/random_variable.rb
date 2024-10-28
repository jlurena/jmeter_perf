module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RandomVariable
    # @param [Hash] params Parameters for the RandomVariable element (default: `{}`).
    # @yield block to attach to the RandomVariable element
    # @return [JmeterPerf::RandomVariable], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#randomvariable
    def random_variable(params = {}, &)
      node = RandomVariable.new(params)
      attach_node(node, &)
    end

    class RandomVariable
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "RandomVariable" : (params[:name] || "RandomVariable")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <RandomVariableConfig guiclass="TestBeanGUI" testclass="RandomVariableConfig" testname="#{testname}" enabled="true">
              <stringProp name="maximumValue"/>
              <stringProp name="minimumValue">1</stringProp>
              <stringProp name="outputFormat"/>
              <boolProp name="perThread">false</boolProp>
              <stringProp name="randomSeed"/>
              <stringProp name="variableName"/>
            </RandomVariableConfig>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
