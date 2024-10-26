module JmeterPerf
  class DSL
    # DSL method synonymous with the JMeter Element FTPRequest
    # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation#ftprequest
    # @param [Hash] params Parameters for the FTPRequest element (default: `{}`).
    # @yield block to attach to the FTPRequest element
    # @return [JmeterPerf::FTPRequest], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
    def ftp_request(params = {}, &)
      node = JmeterPerf::FTPRequest.new(params)
      attach_node(node, &)
    end
  end

  class FTPRequest
    attr_accessor :doc
    include Helper

    def initialize(params = {})
      testname = params.is_a?(Array) ? "FTPRequest" : (params[:name] || "FTPRequest")
      @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        <FTPSampler guiclass="FtpTestSamplerGui" testclass="FTPSampler" testname="#{testname}" enabled="true">
          <stringProp name="FTPSampler.server"/>
          <stringProp name="FTPSampler.port"/>
          <stringProp name="FTPSampler.filename"/>
          <stringProp name="FTPSampler.localfilename"/>
          <stringProp name="FTPSampler.inputdata"/>
          <boolProp name="FTPSampler.binarymode">false</boolProp>
          <boolProp name="FTPSampler.saveresponse">false</boolProp>
          <boolProp name="FTPSampler.upload">false</boolProp>
          <stringProp name="ConfigTestElement.username"/>
          <stringProp name="ConfigTestElement.password"/>
        </FTPSampler>
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
