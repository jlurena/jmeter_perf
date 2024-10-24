module JmeterPerf
  class DSL
    def simple_config_element(params = {}, &)
      node = JmeterPerf::SimpleConfigElement.new(params)
      attach_node(node, &)
    end
  end

  class SimpleConfigElement
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "SimpleConfigElement" : (params[:name] || "SimpleConfigElement")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ConfigTestElement guiclass="SimpleConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
