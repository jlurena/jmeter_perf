module JmeterPerf
  class ExtendedDSL < DSL
    def extract(params, &)
      node = if params[:regex]
        params[:refname] = params[:name]
        params[:template] = params[:template] || "$1$"
        JmeterPerf::RegularExpressionExtractor.new(params)
      elsif params[:xpath]
        params[:refname] = params[:name]
        params[:xpathQuery] = params[:xpath]
        JmeterPerf::XpathExtractor.new(params)
      elsif params[:json]
        params[:VAR] = params[:name]
        params[:JSONPATH] = params[:json]
        JmeterPerf::Plugins::JsonPathExtractor.new(params)
      elsif params[:css]
        params[:refname] = params[:name]
        params[:expr] = params[:css]
        JmeterPerf::CssjqueryExtractor.new(params)
      end

      attach_node(node, &)
    end

    alias_method :web_reg_save_param, :extract
  end
end
