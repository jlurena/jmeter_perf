module JmeterPerf
  module Plugins
    class ConsoleStatusLogger
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater
      def initialize(params = {})
        testname = params.is_a?(Array) ? "ConsoleStatusLogger" : (params[:name] || "ConsoleStatusLogger")
        @doc = Nokogiri::XML(
          JmeterPerf::Helpers::String.strip_heredoc(
            <<-EOF
            <kg.apc.jmeter.reporters.ConsoleStatusLogger guiclass="kg.apc.jmeter.reporters.ConsoleStatusLoggerGui" testclass="kg.apc.jmeter.reporters.ConsoleStatusLogger" testname="#{testname}" enabled="true"/>
            EOF
          )
        )
        update params
      end
    end
  end
end
