module JmeterPerf
  class DSL
    def uniform_random_timer(params = {}, &)
      node = JmeterPerf::UniformRandomTimer.new(params)
      attach_node(node, &)
    end
  end

  class UniformRandomTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "UniformRandomTimer" : (params[:name] || "UniformRandomTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <UniformRandomTimer guiclass="UniformRandomTimerGui" testclass="UniformRandomTimer" testname="#{testname}" enabled="true">
          <stringProp name="ConstantTimer.delay">0</stringProp>
          <stringProp name="RandomTimer.range">100.0</stringProp>
        </UniformRandomTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
