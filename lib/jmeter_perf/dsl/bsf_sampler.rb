module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element BSFSampler
    # @param [Hash] params Parameters for the BSFSampler element (default: `{}`).
    # @yield block to attach to the BSFSampler element
    # @return [JmeterPerf::BSFSampler], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#bsfsampler
    def bsf_sampler(params = {}, &)
      node = BSFSampler.new(params)
      attach_node(node, &)
    end

    class BSFSampler
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "BSFSampler" : (params[:name] || "BSFSampler")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <BSFSampler guiclass="TestBeanGUI" testclass="BSFSampler" testname="#{testname}" enabled="true">
              <stringProp name="filename"/>
              <stringProp name="parameters"/>
              <stringProp name="script"/>
              <stringProp name="scriptLanguage"/>
            </BSFSampler>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
