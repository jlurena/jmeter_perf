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

    write_methods_to_file(methods)
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

  def generate_methods(results)
    methods = []
    methods << "# JmeterPerf::DSL methods"

    results.each do |element|
      klass = element.attributes["testname"].to_s.classify
      methods << "- #{klass}\n  `#{klass.underscore}`"
    end

    methods
  end

  def create_dsl_files(results)
    FileUtils.rm_rf(@dsl_dir)
    FileUtils.mkdir_p(@dsl_dir)

    results.each do |element|
      klass = element.attributes["testname"].to_s.classify
      File.write("#{@dsl_dir}/#{klass.underscore}.rb", <<~EOC)
        module JmeterPerf
          class DSL
            def #{klass.underscore}(params={}, &block)
              node = JmeterPerf::#{klass}.new(params)
              attach_node(node, &block)
            end
          end

          class #{klass}
            attr_accessor :doc
            include Helper

            def initialize(params={})
              testname = params.is_a?(Array) ? '#{klass}' : (params[:name] || '#{klass}')
              @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
        #{element.to_xml.gsub(/testname=".+?"/, 'testname="#{testname}"')}
              EOS
              update params
              update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
            end
          end
        end
      EOC
    end
  end

  def write_methods_to_file(methods)
    File.write("#{@lib_dir}/../DSL.md", methods.join("\n"))
  end
end
