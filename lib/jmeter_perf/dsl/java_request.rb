module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JavaRequest
    # @param params [Hash] Parameters for the JavaRequest element (default: `{}`).
    # @yield block to attach to the JavaRequest element
    # @return [JmeterPerf::JavaRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#javarequest
    def java_request(params = {}, &)
      node = JavaRequest.new(params)
      attach_node(node, &)
    end

    class JavaRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JavaRequest" : (params[:name] || "JavaRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JavaSampler guiclass="JavaTestSamplerGui" testclass="JavaSampler" testname="#{testname}" enabled="true">
              <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" enabled="true">
                <collectionProp name="Arguments.arguments">
                  <elementProp name="Sleep_Time" elementType="Argument">
                    <stringProp name="Argument.name">Sleep_Time</stringProp>
                    <stringProp name="Argument.value">100</stringProp>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="Sleep_Mask" elementType="Argument">
                    <stringProp name="Argument.name">Sleep_Mask</stringProp>
                    <stringProp name="Argument.value">0xFF</stringProp>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="Label" elementType="Argument">
                    <stringProp name="Argument.name">Label</stringProp>
                    <stringProp name="Argument.value"/>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="ResponseCode" elementType="Argument">
                    <stringProp name="Argument.name">ResponseCode</stringProp>
                    <stringProp name="Argument.value"/>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="ResponseMessage" elementType="Argument">
                    <stringProp name="Argument.name">ResponseMessage</stringProp>
                    <stringProp name="Argument.value"/>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="Status" elementType="Argument">
                    <stringProp name="Argument.name">Status</stringProp>
                    <stringProp name="Argument.value">OK</stringProp>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="SamplerData" elementType="Argument">
                    <stringProp name="Argument.name">SamplerData</stringProp>
                    <stringProp name="Argument.value"/>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                  <elementProp name="ResultData" elementType="Argument">
                    <stringProp name="Argument.name">ResultData</stringProp>
                    <stringProp name="Argument.value"/>
                    <stringProp name="Argument.metadata">=</stringProp>
                  </elementProp>
                </collectionProp>
              </elementProp>
              <stringProp name="classname">org.apache.jmeter.protocol.java.test.JavaTest</stringProp>
            </JavaSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
