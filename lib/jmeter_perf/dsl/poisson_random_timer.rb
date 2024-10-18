module JmeterPerf
  class DSL
    def poisson_random_timer(params = {}, &)
      node = JmeterPerf::PoissonRandomTimer.new(params)
      attach_node(node, &)
    end
  end

  class PoissonRandomTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "PoissonRandomTimer" : (params[:name] || "PoissonRandomTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <PoissonRandomTimer guiclass="PoissonRandomTimerGui" testclass="PoissonRandomTimer" testname="#{testname}" enabled="true">
          <stringProp name="ConstantTimer.delay">300</stringProp>
          <stringProp name="RandomTimer.range">100</stringProp>
        </PoissonRandomTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
