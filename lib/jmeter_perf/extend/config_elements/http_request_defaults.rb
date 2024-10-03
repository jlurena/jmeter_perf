module JmeterPerf
  class ExtendedDSL < DSL
    def http_request_defaults(params = {}, &)
      params[:image_parser] = true if params.key? :download_resources
      params[:concurrentDwn] = true if params.key? :use_concurrent_pool
      params[:concurrentPool] = params[:use_concurrent_pool] if params.key? :use_concurrent_pool

      node = JmeterPerf::HttpRequestDefaults.new(params).tap do |node|
        if params[:urls_must_match]
          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="HTTPSampler.embedded_url_re">#{params[:urls_must_match]}</stringProp>
            EOS
          )
        end

        if params[:md5]
          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <boolProp name="HTTPSampler.md5">true</stringProp>
            EOS
          )
        end

        if params[:proxy_host]
          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="HTTPSampler.proxyHost">#{params[:proxy_host]}</stringProp>
            EOS
          )
        end

        if params[:proxy_port]
          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="HTTPSampler.proxyPort">#{params[:proxy_port]}</stringProp>
            EOS
          )
        end
      end

      attach_node(node, &)
    end

    alias_method :defaults, :http_request_defaults
  end
end
