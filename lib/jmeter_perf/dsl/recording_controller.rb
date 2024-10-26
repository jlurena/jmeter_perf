module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RecordingController
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#recordingcontroller
    # @param [Hash] params Parameters for the RecordingController element (default: `{}`).
    # @yield block to attach to the RecordingController element
    # @return [JmeterPerf::RecordingController], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def recording_controller(params = {}, &)
      node = JmeterPerf::RecordingController.new(params)
      attach_node(node, &)
    end
  end

  class RecordingController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "RecordingController" : (params[:name] || "RecordingController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <RecordingController guiclass="RecordController" testclass="RecordingController" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
