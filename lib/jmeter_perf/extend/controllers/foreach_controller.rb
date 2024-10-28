module JmeterPerf
  class ExtendedDSL < DSL
    def foreach_controller(params = {}, &)
      node = JmeterPerf::ForeachController.new(params).tap do |node|
        if params[:start_index]
          params[:startIndex] = params[:start_index]
          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
                <stringProp name="ForeachController.startIndex"/>
              EOS
            )).children
          )
        end

        if params[:end_index]
          params[:endIndex] = params[:end_index]
          node.doc.children.first.add_child(
            Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
              <<-EOS
                <stringProp name="ForeachController.endIndex"/>
              EOS
            )).children
          )
        end
      end

      attach_node(node, &)
    end
  end
end
