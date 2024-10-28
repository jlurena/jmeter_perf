module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element JUnitRequest
    # @param [Hash] params Parameters for the JUnitRequest element (default: `{}`).
    # @yield block to attach to the JUnitRequest element
    # @return [JmeterPerf::JUnitRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#junitrequest
    def j_unit_request(params = {}, &)
      node = JUnitRequest.new(params)
      attach_node(node, &)
    end

    class JUnitRequest
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "JUnitRequest" : (params[:name] || "JUnitRequest")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <JUnitSampler guiclass="JUnitTestSamplerGui" testclass="JUnitSampler" testname="#{testname}" enabled="true">
              <stringProp name="junitSampler.classname">test.RerunTest</stringProp>
              <stringProp name="junitsampler.constructorstring"/>
              <stringProp name="junitsampler.method">testRerun</stringProp>
              <stringProp name="junitsampler.pkg.filter"/>
              <stringProp name="junitsampler.success">Test successful</stringProp>
              <stringProp name="junitsampler.success.code">1000</stringProp>
              <stringProp name="junitsampler.failure">Test failed</stringProp>
              <stringProp name="junitsampler.failure.code">0001</stringProp>
              <stringProp name="junitsampler.error">An unexpected error occured</stringProp>
              <stringProp name="junitsampler.error.code">9999</stringProp>
              <stringProp name="junitsampler.exec.setup">false</stringProp>
              <stringProp name="junitsampler.append.error">false</stringProp>
              <stringProp name="junitsampler.append.exception">false</stringProp>
            </JUnitSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
