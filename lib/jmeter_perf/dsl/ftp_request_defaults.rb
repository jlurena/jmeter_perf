module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element FTPRequestDefaults
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ftprequestdefaults
    # @param [Hash] params Parameters for the FTPRequestDefaults element (default: `{}`).
    # @yield block to attach to the FTPRequestDefaults element
    # @return [JmeterPerf::FTPRequestDefaults], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def ftp_request_defaults(params = {}, &)
      node = JmeterPerf::FTPRequestDefaults.new(params)
      attach_node(node, &)
    end
  end

  class FTPRequestDefaults
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "FTPRequestDefaults" : (params[:name] || "FTPRequestDefaults")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <ConfigTestElement guiclass="FtpConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
          <stringProp name="FTPSampler.server"/>
          <stringProp name="FTPSampler.port"/>
          <stringProp name="FTPSampler.filename"/>
          <stringProp name="FTPSampler.localfilename"/>
          <stringProp name="FTPSampler.inputdata"/>
          <boolProp name="FTPSampler.binarymode">false</boolProp>
          <boolProp name="FTPSampler.saveresponse">false</boolProp>
          <boolProp name="FTPSampler.upload">false</boolProp>
        </ConfigTestElement>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
