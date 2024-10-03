module JmeterPerf
  class ExtendedDSL < DSL
    def http_request(*args, &)
      params = args.shift || {}
      params = {url: params}.merge(args.shift || {}) if params.is_a?(String)

      params[:method] ||= case __callee__.to_s
      when "visit"
        "GET"
      when "submit"
        "POST"
      else
        __callee__.to_s.upcase
      end

      params[:name] ||= params[:url]

      parse_http_request(params)

      if params[:sample]
        transaction name: params[:name], parent: true do
          loops count: params[:sample].to_i do
            params.delete(:sample)
            attach_node(http_request_node(params), &block)
          end
        end
      else
        attach_node(http_request_node(params), &)
      end
    end

    def http_request_node(params)
      JmeterPerf::HTTPRequest.new(params).tap do |node|
        if params[:implementation]
          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="HTTPSampler.implementation">#{params[:implementation]}</stringProp>
            EOS
          )
        end

        if params[:comments]
          node.doc.children.first.add_child(
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="TestPlan.comments">#{params[:comments]}</stringProp>
            EOS
          )
        end
      end
    end

    alias_method :request, :http_request
    alias_method :get, :http_request
    alias_method :visit, :http_request
    alias_method :post, :http_request
    alias_method :submit, :http_request
    alias_method :delete, :http_request
    alias_method :patch, :http_request
    alias_method :put, :http_request
    alias_method :head, :http_request
  end
end
