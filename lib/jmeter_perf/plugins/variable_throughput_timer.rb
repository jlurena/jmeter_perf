module JmeterPerf
  module Plugins
    class ThroughputShapingTimer
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater
      def initialize(params = {})
        testname = params.is_a?(Array) ? "ThroughputShapingTimer" : (params[:name] || "ThroughputShapingTimer")
        @doc = Nokogiri::XML(
          JmeterPerf::Helpers::String.strip_heredoc(
            <<-EOF
              <kg.apc.jmeter.timers.VariableThroughputTimer guiclass="kg.apc.jmeter.timers.VariableThroughputTimerGui" testclass="kg.apc.jmeter.timers.VariableThroughputTimer" testname="#{testname}" enabled="true">
                <collectionProp name="load_profile"/>
              </kg.apc.jmeter.timers.VariableThroughputTimer>
            EOF
          )
        )

        (params.is_a?(Array) ? params : params[:steps]).each_with_index do |step, index|
          @doc.at_xpath("//collectionProp") << Nokogiri::XML(
            JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOF
                  <collectionProp name="step_#{index}">
                    <stringProp name="start_rps_#{index}">#{step[:start_rps]}</stringProp>
                    <stringProp name="end_rps_#{index}">#{step[:end_rps]}</stringProp>
                    <stringProp name="duration_sec_#{index}">#{step[:duration]}</stringProp>
                  </collectionProp>
              EOF
            )
          ).children
        end
        update params
      end
    end
  end
end
