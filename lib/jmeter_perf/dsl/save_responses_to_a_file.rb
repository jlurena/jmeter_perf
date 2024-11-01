module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element SaveResponsesToAFile
    # @param params [Hash] Parameters for the SaveResponsesToAFile element (default: `{}`).
    # @yield block to attach to the SaveResponsesToAFile element
    # @return [JmeterPerf::SaveResponsesToAFile], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#saveresponsestoafile
    def save_responses_to_a_file(params = {}, &)
      node = SaveResponsesToAFile.new(params)
      attach_node(node, &)
    end

    class SaveResponsesToAFile
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "SaveResponsesToAFile" : (params[:name] || "SaveResponsesToAFile")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <ResultSaver guiclass="ResultSaverGui" testclass="ResultSaver" testname="#{testname}" enabled="true">
              <stringProp name="FileSaver.filename"/>
              <boolProp name="FileSaver.errorsonly">false</boolProp>
              <boolProp name="FileSaver.skipautonumber">false</boolProp>
              <boolProp name="FileSaver.skipsuffix">false</boolProp>
              <boolProp name="FileSaver.successonly">false</boolProp>
            </ResultSaver>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
