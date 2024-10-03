module JmeterPerf
  class DSL
    def recording_controller(params={}, &block)
      node = JmeterPerf::RecordingController.new(params)
      attach_node(node, &block)
    end
  end

  class RecordingController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'RecordingController' : (params[:name] || 'RecordingController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RecordingController guiclass="RecordController" testclass="RecordingController" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
