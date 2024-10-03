module JmeterPerf
  class DSL
    def reg_ex_user_parameters(params={}, &block)
      node = JmeterPerf::RegExUserParameters.new(params)
      attach_node(node, &block)
    end
  end

  class RegExUserParameters
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'RegExUserParameters' : (params[:name] || 'RegExUserParameters')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RegExUserParameters guiclass="RegExUserParametersGui" testclass="RegExUserParameters" testname="#{testname}" enabled="true">
  <stringProp name="RegExUserParameters.regex_ref_name"/>
  <stringProp name="RegExUserParameters.param_names_gr_nr"/>
  <stringProp name="RegExUserParameters.param_values_gr_nr"/>
</RegExUserParameters>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
