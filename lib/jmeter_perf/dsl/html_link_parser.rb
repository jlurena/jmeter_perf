module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTMLLinkParser
    # @param [Hash] params Parameters for the HTMLLinkParser element (default: `{}`).
    # @yield block to attach to the HTMLLinkParser element
    # @return [JmeterPerf::HTMLLinkParser], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#htmllinkparser
    def html_link_parser(params = {}, &)
      node = HTMLLinkParser.new(params)
      attach_node(node, &)
    end

    class HTMLLinkParser
      attr_accessor :doc
      include JmeterPerf::Helpers::XmlDocumentUpdater

      def initialize(params = {})
        testname = params.is_a?(Array) ? "HTMLLinkParser" : (params[:name] || "HTMLLinkParser")
        @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
          <<~EOS
            <AnchorModifier guiclass="AnchorModifierGui" testclass="AnchorModifier" testname="#{testname}" enabled="true"/>
          EOS
        ))
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end
