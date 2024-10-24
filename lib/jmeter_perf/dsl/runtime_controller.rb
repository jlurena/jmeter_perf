module JmeterPerf
  class DSL
    def runtime_controller(params = {}, &)
      node = JmeterPerf::RuntimeController.new(params)
      attach_node(node, &)
    end
  end

  class RuntimeController
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "RuntimeController" : (params[:name] || "RuntimeController")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <RunTime guiclass="RunTimeGui" testclass="RunTime" testname="#{testname}" enabled="true">
          <stringProp name="RunTime.seconds">1</stringProp>
        </RunTime>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
