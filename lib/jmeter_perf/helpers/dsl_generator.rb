require "nokogiri"
require "pathname"

require_relative "string"

module JmeterPerf
  module Helpers
    # The DSLGenerator class generates the DSL methods and files
    # for use in JMeter performance testing scripts. It uses a JMeter TestPlan (idl.xml)
    # to generate the methods and files.
    # @see https://github.com/jlurena/jmeter_perf/wiki/3.-Generating-DSL-Methods
    class DSLGenerator
      # Initializes the DSLGenerator.
      # @param dsl_dir [String] Path to the directory where DSL files will be generated.
      # @param idl_xml_path [String] Path to the XML file used for generating methods.
      def initialize(dsl_dir:, idl_xml_path:, document_dsl: true)
        @document_dsl = document_dsl
        @dsl_dir = dsl_dir
        @idl_xml_path = idl_xml_path
      end

      # Main method to generate DSL files and methods.
      # It parses the XML, generates methods, documents,
      # updates RBS files, and creates individual DSL files.
      # @return [void]
      def generate
        results = parse_xml
        methods = generate_methods(results)

        write_methods_to_dsl_md(methods) if @document_dsl
        update_rbs(methods) if @document_dsl
        create_dsl_files(results)
      end

      private

      # Parses the XML file specified by the `idl_xml_path` parameter.
      # @return [Array<Nokogiri::XML::Node>] Array of XML nodes representing valid elements.
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

      # Checks if a given Nokogiri XML node is valid based on specific criteria.
      #
      # A node is considered valid if:
      # - It is not an instance of Nokogiri::XML::Document.
      # - It has an attribute named "testclass".
      # - Its name is not "elementProp".
      #
      # @param node [Nokogiri::XML::Node] The XML node to be validated.
      # @return [Boolean] Returns true if the node is valid, false otherwise.
      def valid_node?(node)
        node.class != Nokogiri::XML::Document &&
          node.attributes["testclass"] &&
          node.name != "elementProp"
      end

      # Generates methods based on parsed XML results.
      # @param results [Array<Nokogiri::XML::Node>] Parsed XML nodes.
      # @return [Array<Array<String>>] Array of class and method name pairs.
      def generate_methods(results)
        results.map do |element|
          klass = JmeterPerf::Helpers::String.classify(element.attributes["testname"].to_s)
          method = JmeterPerf::Helpers::String.underscore(klass)
          [klass, method]
        end.sort_by(&:first)
      end

      # Creates individual DSL files based on parsed XML results.
      # @param results [Array<Nokogiri::XML::Node>] Parsed XML nodes.
      # @return [void]
      def create_dsl_files(results)
        FileUtils.rm_rf(@dsl_dir)
        FileUtils.mkdir_p(@dsl_dir)

        results.each do |element|
          klass = JmeterPerf::Helpers::String.classify(element.attributes["testname"].to_s)
          puts "\tfor Element #{klass}"
          File.write("#{@dsl_dir}/#{JmeterPerf::Helpers::String.underscore(klass)}.rb", <<~EOC)
            module JmeterPerf
              class DSL
                # DSL method synonymous with the JMeter Element #{klass}
                # @param params [Hash] Parameters for the #{klass} element (default: `{}`).
                # @yield block to attach to the #{klass} element
                # @return [JmeterPerf::#{klass}], a subclass of JmeterPerf::DSL that can be chained with other DSL methods.
                # @see https://github.com/jlurena/jmeter_perf/wiki/1.-DSL-Documentation##{klass.downcase}
                def #{JmeterPerf::Helpers::String.underscore(klass)}(params = {}, &)
                  node = #{klass}.new(params)
                  attach_node(node, &)
                end

                class #{klass}
                  attr_accessor :doc
                  include JmeterPerf::Helpers::XmlDocumentUpdater

                  def initialize(params = {})
                    testname = params.is_a?(Array) ? "#{klass}" : (params[:name] || "#{klass}")
                    @doc = Nokogiri::XML(JmeterPerf::Helpers::String.strip_heredoc(
                      <<~EOS
            #{element.to_xml.gsub(/testname=".+?"/, 'testname="#{testname}"').gsub(/^/, "            ")}
                      EOS
                    ))
                    update params
                    update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
                  end
                end
              end
            end
          EOC
        end
      end

      # Updates the RBS file with method signatures for the DSL methods.
      # @param methods [Array<Array<String>>] Array of class and method name pairs.
      # @return [void]
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

      # Writes the list of generated methods to a markdown file.
      # @param methods [Array<Array<String>>] Array of class and method name pairs.
      # @return [void]
      def write_methods_to_dsl_md(methods)
        output = []
        output << "# JmeterPerf::DSL methods"

        methods.each do |klass, method|
          output << "- #{klass}\n  `#{method}`"
        end

        File.write("DSL.md", output.join("\n"))
      end
    end
  end
end
