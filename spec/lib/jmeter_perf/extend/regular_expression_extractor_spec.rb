require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "regular_expression_extractor" do
    describe "#regex" do
      context "standard scope" do
        let(:test_plan) do
          JmeterPerf.test do
            regex pattern: "pattern", name: "my_variable", match_number: 1, default: "424242"
          end
        end

        let(:fragment) { doc.search("//RegexExtractor").first }

        it "matches on refname" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq "my_variable"
        end

        it "matches on regex" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq "pattern"
        end

        it "matches on template" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq "$1$"
        end

        it "matches on match_number" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.match_number']").text).to eq "1"
        end

        it "matches on default" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.default']").text).to eq "424242"
        end

        it "matches on scope" do
          expect(fragment.search(".//stringProp[@name='Sample.scope']").text).to eq "all"
        end
      end

      context "variable scope" do
        let(:test_plan) do
          JmeterPerf.test do
            regex pattern: "pattern", name: "my_variable", variable: "test_variable"
          end
        end

        let(:fragment) { doc.search("//RegexExtractor").first }

        it "matches on refname" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq "my_variable"
        end

        it "matches on regex" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq "pattern"
        end

        it "matches on template" do
          expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq "$1$"
        end

        it "matches on scope" do
          expect(fragment.search(".//stringProp[@name='Sample.scope']").text).to eq "variable"
        end
      end
    end
  end
end
