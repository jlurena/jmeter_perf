module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element MD5HexAssertion
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#md5hexassertion
    # @param [Hash] params Parameters for the MD5HexAssertion element (default: `{}`).
    # @yield block to attach to the MD5HexAssertion element
    # @return [JmeterPerf::MD5HexAssertion], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
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
