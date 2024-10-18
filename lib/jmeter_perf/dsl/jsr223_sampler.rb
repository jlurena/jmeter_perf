module JmeterPerf
  class DSL
    def jsr223_sampler(params = {}, &)
      node = JmeterPerf::JSR223Sampler.new(params)
      attach_node(node, &)
    end
  end

  class JSR223Sampler
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "JSR223Sampler" : (params[:name] || "JSR223Sampler")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <JSR223Sampler guiclass="TestBeanGUI" testclass="JSR223Sampler" testname="#{testname}" enabled="true">
          <stringProp name="cacheKey"/>
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <stringProp name="script"/>
          <stringProp name="scriptLanguage"/>
        </JSR223Sampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
