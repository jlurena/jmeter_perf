module JmeterPerf
  class ExtendedDSL < DSL
    def module_controller(params, &)
      node = JmeterPerf::DSL::ModuleController.new(params)

      if params[:test_fragment]
        params[:test_fragment].is_a?(String) &&
          params[:test_fragment].split("/")
      elsif params[:node_path]
        params[:node_path]
      else
        []
      end.each_with_index do |node_name, index|
        node.doc.at_xpath("//collectionProp") << Nokogiri::XML(
          JmeterPerf::Helpers::String.strip_heredoc(
            <<-EOS
              <stringProp name="node_#{index}">#{node_name}</stringProp>
            EOS
          )
        ).children
      end

      attach_node(node, &)
    end
  end
end
