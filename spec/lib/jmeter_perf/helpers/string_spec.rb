require "spec_helper"

RSpec.describe JmeterPerf::Helpers::String do
  describe ".classify" do
    it "converts underscored strings to CamelCase" do
      expect(described_class.classify("some_test")).to eq("SomeTest")
    end

    it "replaces spaces with underscores before CamelCasing" do
      expect(described_class.classify("some test")).to eq("SomeTest")
    end

    it "converts lowercase words separated by spaces to CamelCase" do
      expect(described_class.classify("some long test name")).to eq("SomeLongTestName")
    end

    it "handles already CamelCased strings" do
      expect(described_class.classify("SomeTest")).to eq("SomeTest")
    end
  end

  describe ".underscore" do
    it "converts CamelCase to snake_case" do
      expect(described_class.underscore("SomeTest")).to eq("some_test")
    end

    it 'handles namespaced classes by converting "::" to slashes' do
      expect(described_class.underscore("SomeModule::SomeClass")).to eq("some_module/some_class")
    end

    it "handles complex cases with acronyms" do
      expect(described_class.underscore("HTTPServer")).to eq("http_server")
    end

    it "converts hyphens to underscores" do
      expect(described_class.underscore("some-test")).to eq("some_test")
    end

    it "handles strings that are already in snake_case" do
      expect(described_class.underscore("some_test")).to eq("some_test")
    end
  end

  describe ".camelize" do
    it "converts snake_case to CamelCase" do
      expect(described_class.camelize("some_test")).to eq("SomeTest")
    end

    it "converts snake_case to lowerCamelCase when :lower is passed" do
      expect(described_class.camelize("some_test", :lower)).to eq("someTest")
    end

    it "handles namespaced classes, converts flat" do
      expect(described_class.camelize("some_module/some_class")).to eq("SomeModuleSomeClass")
    end

    it "does not modify strings that are already CamelCase" do
      expect(described_class.camelize("SomeTest")).to eq("SomeTest")
    end

    it "handles all-lowercase strings" do
      expect(described_class.camelize("sometest")).to eq("Sometest")
    end
  end

  describe ".strip_heredoc" do
    it "removes leading whitespace based on the indentation of the first line" do
      input = <<-HEREDOC
        This is a test.
          This line is indented.
        This line is also indented.
      HEREDOC

      expect(described_class.strip_heredoc(input)).to eq("This is a test.\n  This line is indented.\nThis line is also indented.\n")
    end

    it "handles strings with no indentation" do
      input = <<-HEREDOC
      This is a test.
      No indentation here.
      HEREDOC

      expect(described_class.strip_heredoc(input)).to eq("This is a test.\nNo indentation here.\n")
    end

    it "returns an empty string when the input is empty" do
      input = ""

      expect(described_class.strip_heredoc(input)).to eq("")
    end

    it "returns the same string if there is no common leading whitespace" do
      input = <<-HEREDOC
      This line
      is on its own.
      HEREDOC

      expect(described_class.strip_heredoc(input)).to eq("This line\nis on its own.\n")
    end

    it "handles strings with mixed indentation" do
      input = <<-HEREDOC
        This line is indented.
          This line is more indented.
        This line is indented.
      HEREDOC

      expect(described_class.strip_heredoc(input)).to eq("This line is indented.\n  This line is more indented.\nThis line is indented.\n")
    end
  end
end
