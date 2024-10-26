module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RandomVariable
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#randomvariable
    # @param [Hash] params Parameters for the RandomVariable element (default: `{}`).
    # @yield block to attach to the RandomVariable element
    # @return [JmeterPerf::RandomVariable], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def random_variable(params = {}, &)
      node = JmeterPerf::RandomVariable.new(params)
      attach_node(node, &)
    end
  end

  class RandomVariable
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "RandomVariable" : (params[:name] || "RandomVariable")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <RandomVariableConfig guiclass="TestBeanGUI" testclass="RandomVariableConfig" testname="#{testname}" enabled="true">
          <stringProp name="maximumValue"/>
          <stringProp name="minimumValue">1</stringProp>
          <stringProp name="outputFormat"/>
          <boolProp name="perThread">false</boolProp>
          <stringProp name="randomSeed"/>
          <stringProp name="variableName"/>
        </RandomVariableConfig>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
