module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element RegExUserParameters
    # @param [Hash] params Parameters for the RegExUserParameters element (default: `{}`).
    # @yield block to attach to the RegExUserParameters element
    # @return [JmeterPerf::RegExUserParameters], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#regexuserparameters
    def reg_ex_user_parameters(params = {}, &)
      node = RegExUserParameters.new(params)
      attach_node(node, &)
    end

    class RegExUserParameters
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "RegExUserParameters" : (params[:name] || "RegExUserParameters")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <RegExUserParameters guiclass="RegExUserParametersGui" testclass="RegExUserParameters" testname="#{testname}" enabled="true">
              <stringProp name="RegExUserParameters.regex_ref_name"/>
              <stringProp name="RegExUserParameters.param_names_gr_nr"/>
              <stringProp name="RegExUserParameters.param_values_gr_nr"/>
            </RegExUserParameters>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
