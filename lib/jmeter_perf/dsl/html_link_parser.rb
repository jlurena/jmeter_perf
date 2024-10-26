module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element HTMLLinkParser
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#htmllinkparser
    # @param [Hash] params Parameters for the HTMLLinkParser element (default: `{}`).
    # @yield block to attach to the HTMLLinkParser element
    # @return [JmeterPerf::HTMLLinkParser], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def html_link_parser(params = {}, &)
      node = JmeterPerf::HTMLLinkParser.new(params)
      attach_node(node, &)
    end
  end

  class HTMLLinkParser
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "HTMLLinkParser" : (params[:name] || "HTMLLinkParser")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <AnchorModifier guiclass="AnchorModifierGui" testclass="AnchorModifier" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
