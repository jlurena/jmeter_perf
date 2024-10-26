module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BeanShellTimer
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#beanshelltimer
    # @param [Hash] params Parameters for the BeanShellTimer element (default: `{}`).
    # @yield block to attach to the BeanShellTimer element
    # @return [JmeterPerf::BeanShellTimer], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def bean_shell_timer(params = {}, &)
      node = JmeterPerf::BeanShellTimer.new(params)
      attach_node(node, &)
    end
  end

  class BeanShellTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "BeanShellTimer" : (params[:name] || "BeanShellTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <BeanShellTimer guiclass="TestBeanGUI" testclass="BeanShellTimer" testname="#{testname}" enabled="true">
          <stringProp name="filename"/>
          <stringProp name="parameters"/>
          <boolProp name="resetInterpreter">false</boolProp>
          <stringProp name="script"/>
        </BeanShellTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
