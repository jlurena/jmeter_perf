require "nokogiri"
require "pathname"

require_relative "string"

class DSLGenerator
  def initialize(lib_dir:, gem_dir:, dsl_dir:, idl_xml_path:)
    @lib_dir = Pathname(lib_dir)
    @gem_dir = gem_dir
    @dsl_dir = dsl_dir
    @idl_xml_path = idl_xml_path
  end

  def generate
    results = parse_xml
    methods = generate_methods(results)

    write_methods_to_dsl_md(methods)
    update_rbs(methods)
    create_dsl_files(results)
  end

  private

  def parse_xml
    idl_xml = File.open(@idl_xml_path)
    doc = Nokogiri::XML(idl_xml.read.gsub(/\n\s+/, ""))
    results = []

    doc.traverse do |node|
      if valid_node?(node)
        results << node
      end
    end

    results
  end

  def valid_node?(node)
    node.class != Nokogiri::XML::Document &&
      node.attributes["testclass"] &&
      node.name != "elementProp"
  end

  # Generate methods for DSL.
  # @return [Array<Array<String>>] Array of [class_name, method_name]
  def generate_methods(results)
    results.map do |element|
      klass = element.attributes["testname"].to_s.classify
      method = klass.underscore
      [klass, method]
    end
  end

  def create_dsl_files(results)
    FileUtils.rm_rf(@dsl_dir)
    FileUtils.mkdir_p(@dsl_dir)

    results.each do |element|
      klass = element.attributes["testname"].to_s.classify
      File.write("#{@dsl_dir}/#{klass.underscore}.rb", <<~EOC)
        module JmeterPerf
          class DSL
            def #{klass.underscore}(params = {}, &)
              node = JmeterPerf::#{klass}.new(params)
              attach_node(node, &)
            end
          end

          class #{klass}
            attr_accessor :doc
            include Helper

            def initialize(params = {})
              testname = params.is_a?(Array) ? "#{klass}" : (params[:name] || "#{klass}")
              @doc = Nokogiri::XML(<<~EOS.strip_heredoc)
        #{element.to_xml.gsub(/testname=".+?"/, 'testname="#{testname}"').gsub(/^/, "        ")}
              EOS
              update params
              update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
            end
          end
        end
      EOC
    end
  end

  def update_rbs(methods)
    file_path = "sig/jmeter_perf.rbs"
    replace_regex = /\s*## AUTOGENERATED - DSL methods RBS(.*?)## AUTOGENERATED - DSL methods RBS/m
    new_content = <<~NEW_CONTENT
      #{methods.map { |klass, method| "    def #{method}: (Hash[Symbol, untyped], &block) -> void" }.join("\n")}
    NEW_CONTENT

    current_content = File.read(file_path)

    new_file_content = current_content.gsub(replace_regex) do
      "\n    ## AUTOGENERATED - DSL methods RBS\n\n#{new_content}\n    ## AUTOGENERATED - DSL methods RBS"
    end

    File.write(file_path, new_file_content)
  end

  def write_methods_to_dsl_md(methods)
    output = []
    output << "# JmeterPerf::DSL methods"

    methods.each do |klass, method|
      output << "- #{klass}\n  `#{method}`"
    end

    File.write("#{@lib_dir}/../DSL.md", output.join("\n"))
  end
end
