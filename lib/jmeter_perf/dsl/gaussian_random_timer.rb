module JmeterPerf
  class DSL
    def gaussian_random_timer(params = {}, &)
      node = JmeterPerf::GaussianRandomTimer.new(params)
      attach_node(node, &)
    end
  end

  class GaussianRandomTimer
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "GaussianRandomTimer" : (params[:name] || "GaussianRandomTimer")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <GaussianRandomTimer guiclass="GaussianRandomTimerGui" testclass="GaussianRandomTimer" testname="#{testname}" enabled="true">
          <stringProp name="ConstantTimer.delay">300</stringProp>
          <stringProp name="RandomTimer.range">100.0</stringProp>
        </GaussianRandomTimer>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
