module JmeterPerf
  class DSL
    def html_link_parser(params={}, &block)
      node = JmeterPerf::HTMLLinkParser.new(params)
      attach_node(node, &block)
    end
  end

  class HTMLLinkParser
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.is_a?(Array) ? 'HTMLLinkParser' : (params[:name] || 'HTMLLinkParser')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AnchorModifier guiclass="AnchorModifierGui" testclass="AnchorModifier" testname="#{testname}" enabled="true"/>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
