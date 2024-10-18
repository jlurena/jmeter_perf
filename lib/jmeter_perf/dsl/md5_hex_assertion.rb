module JmeterPerf
  class DSL
    def md5_hex_assertion(params = {}, &)
      node = JmeterPerf::MD5HexAssertion.new(params)
      attach_node(node, &)
    end
  end

  class MD5HexAssertion
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "MD5HexAssertion" : (params[:name] || "MD5HexAssertion")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <MD5HexAssertion guiclass="MD5HexAssertionGUI" testclass="MD5HexAssertion" testname="#{testname}" enabled="true">
          <stringProp name="MD5HexAssertion.size"/>
        </MD5HexAssertion>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
