# frozen_string_literal: true

module JmeterPerf
  class ExtendedDSL < DSL
    def http_cookie_manager(params = {}, &)
      params[:clearEachIteration] = true if params.key? :clear_each_iteration

      node = JmeterPerf::DSL::HTTPCookieManager.new(params)

      params[:user_defined_cookies]&.each { |cookie| add_cookie_to_collection(cookie, node) }

      attach_node(node, &)
    end

    alias_method :cookies, :http_cookie_manager

    private

    def add_cookie_to_collection(cookie, node)
      raise "Cookie name must be provided." unless cookie[:name]
      raise "Cookie value must be provided." unless cookie[:value]
      node.doc.at_xpath("//collectionProp") << Nokogiri::XML(
        JmeterPerf::Helpers::String.strip_heredoc(
          <<-EOS
            <elementProp name="#{cookie[:name]}" elementType="Cookie" testname="#{cookie[:name]}">
              <stringProp name="Cookie.value">#{cookie[:value]}</stringProp>
              <stringProp name="Cookie.domain">#{cookie[:domain]}</stringProp>
              <stringProp name="Cookie.path">#{cookie[:path]}</stringProp>
              <boolProp name="Cookie.secure">#{cookie[:secure] || false}</boolProp>
              <longProp name="Cookie.expires">0</longProp>
              <boolProp name="Cookie.path_specified">true</boolProp>
              <boolProp name="Cookie.domain_specified">true</boolProp>
            </elementProp>
          EOS
        )
      ).children
    end
  end
end
