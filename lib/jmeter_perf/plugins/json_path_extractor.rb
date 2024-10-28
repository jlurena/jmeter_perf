module JmeterPerf
  module Plugins
    class JsonPathExtractor
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater
      def initialize(params = {})
        @doc = Nokogiri::XML(
          JmeterPerf::Helpers::String.strip_heredoc(
            <<-EOF
              <com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor guiclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.gui.JSONPathExtractorGui" testclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor" testname="jp@gc - JSON Path Extractor" enabled="true">
                <stringProp name="VAR"></stringProp>
                <stringProp name="JSONPATH"></stringProp>
              </com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor>
            EOF
          )
        )
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
