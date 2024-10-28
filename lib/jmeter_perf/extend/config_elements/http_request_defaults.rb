module JmeterPerf
  class ExtendedDSL < DSL
    def http_request_defaults(params = {}, &)
      params[:image_parser] = true if params.key? :download_resources
      params[:concurrentDwn] = true if params.key? :use_concurrent_pool
      params[:concurrentPool] = params[:use_concurrent_pool] if params.key? :use_concurrent_pool

      node = JmeterPerf::DSL::HTTPRequestDefaults.new(params).tap do |node|
        if params[:urls_must_match]
          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
              <stringProp name="HTTPSampler.embedded_url_re">#{params[:urls_must_match]}</stringProp>
              EOS
            )).children
          )
        end

        if params[:md5]
          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
                <boolProp name="HTTPSampler.md5">true</stringProp>
              EOS
            )).children
          )
        end

        if params[:proxy_host]
          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
                <stringProp name="HTTPSampler.proxyHost">#{params[:proxy_host]}</stringProp>
              EOS
            )).children
          )
        end

        if params[:proxy_port]
          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
                <stringProp name="HTTPSampler.proxyPort">#{params[:proxy_port]}</stringProp>
              EOS
            )).children
          )
        end
      end

      attach_node(node, &)
    end

    alias_method :defaults, :http_request_defaults
  end
end
