require "nokogiri"
require "pathname"
require "fileutils"
require "pry-byebug"

RSpec.describe DSLGenerator do
  let(:lib_dir) { Pathname("lib_dir") }
  let(:gem_dir) { lib_dir.join("gem_dir") }
  let(:dsl_dir) { gem_dir.join("dsl") }
  let(:specifications_dir) { lib_dir.join("specifications") }
  let(:idl_xml_path) { specifications_dir.join("idl.xml") }
  let(:xml_content) { '<jmeterTestPlan><hashTree><someElement testclass="SomeTest" testname="some test"/></hashTree></jmeterTestPlan>' }
  let(:xml_element) { Nokogiri::XML(xml_content).at_xpath("//someElement") }
  let(:mock_dsl_file_path) { dsl_dir.join("some_test.rb") }
  let(:dsl_md_file_path) { "#{lib_dir}/../DSL.md" }

  before do
    allow(File).to receive(:open).with(idl_xml_path).and_return(StringIO.new(xml_content))
    allow(File).to receive(:write)
    allow(Dir).to receive(:mkdir_p).with(dsl_dir, 0o700)
    allow(Dir).to receive(:exist?).with(dsl_dir).and_return(false)

    allow(Nokogiri::XML::Document).to receive(:parse).and_return(Nokogiri::XML(xml_content))
  end

  describe "#generate" do
    subject(:dsl_generator) { described_class.new(lib_dir:, gem_dir:, dsl_dir:, idl_xml_path:) }

    it "parses the idl.xml file" do
      expect { dsl_generator.generate }.not_to raise_error
    end

    it "creates the DSL directory if it does not exist" do
      expect(Dir).to receive(:mkdir_p).with(dsl_dir, 0o700)
      dsl_generator.generate
    end

    it "generates a DSL method file for each test element in the XML" do
      expected_dsl_content = <<~RUBY
        module JmeterPerf
          class DSL
            def some_test(params={}, &block)
              node = JmeterPerf::SomeTest.new(params)
              attach_node(node, &block)
            end
          end

          class SomeTest
            attr_accessor :doc
            include Helper

            def initialize(params={})
              testname = params.is_a?(Array) ? 'SomeTest' : (params[:name] || 'SomeTest')
              @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
        #{xml_element.to_xml.gsub(/testname=".+?"/, 'testname="#{testname}"')}
              EOS
              update params
              update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
            end
          end
        end
      RUBY

      expect(File).to receive(:write).with("#{dsl_dir}/some_test.rb", expected_dsl_content)
      dsl_generator.generate
    end

    it "writes the DSL methods documentation to DSL.md" do
      expected_md_content = <<~MARKDOWN
        # JmeterPerf::DSL methods
        - SomeTest
          `some_test`
      MARKDOWN
        .chomp

      expect(File).to receive(:write).with(dsl_md_file_path, expected_md_content)
      dsl_generator.generate
    end
  end
end
