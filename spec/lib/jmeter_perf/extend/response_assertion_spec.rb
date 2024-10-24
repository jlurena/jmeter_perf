require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  describe "response_assertion" do
    describe "#assert" do
      context "standard scope" do
        let(:doc) do
          JmeterPerf.test do
            assert contains: "We test, tune and secure your site"
          end.to_doc
        end

        let(:fragment) { doc.search("//ResponseAssertion").first }

        it "matches on refname" do
          expect(fragment.search(".//stringProp[@name='0']").text).to eq "We test, tune and secure your site"
        end

        it "matches on test_type" do
          expect(fragment.search(".//intProp[@name='Assertion.test_type']").text).to eq "2"
        end

        it "matches on scope" do
          expect(fragment.search(".//stringProp[@name='Assertion.scope']").text).to eq "all"
        end
      end

      context "custom scope" do
        let(:doc) do
          JmeterPerf.test do
            assert "not-contains" => "Something in frames", :scope => "children"
          end.to_doc
        end

        let(:fragment) { doc.search("//ResponseAssertion").first }

        it "matches on refname" do
          expect(fragment.search(".//stringProp[@name='0']").text).to eq "Something in frames"
        end

        it "matches on test_type" do
          expect(fragment.search(".//intProp[@name='Assertion.test_type']").text).to eq "6"
        end

        it "matches on scope" do
          expect(fragment.search(".//stringProp[@name='Assertion.scope']").text).to eq "children"
        end
      end

      context "variable scope" do
        let(:doc) do
          JmeterPerf.test do
            assert "substring" => "Something in frames", :scope => "children", :variable => "test"
          end.to_doc
        end

        let(:fragment) { doc.search("//ResponseAssertion").first }

        it "matches on refname" do
          expect(fragment.search(".//stringProp[@name='0']").text).to eq "Something in frames"
        end

        it "matches on test_type" do
          expect(fragment.search(".//intProp[@name='Assertion.test_type']").text).to eq "16"
        end

        it "matches on scope" do
          expect(fragment.search(".//stringProp[@name='Assertion.scope']").text).to eq "variable"
        end
      end
    end
  end
end
