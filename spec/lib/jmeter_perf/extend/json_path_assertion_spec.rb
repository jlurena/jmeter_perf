require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "assertions" do
    describe "#assert" do
      context "json" do
        let(:test_plan) do
          JmeterPerf.test do
            visit "/" do
              assert json: ".key", value: "value"
            end
          end
        end

        let(:fragment) { doc.search("//com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion").first }

        it "should match on expected value, json path and default to jsonvalidation" do
          expect(fragment.search(".//stringProp[@name='EXPECTED_VALUE']").text).to eq "value"
          expect(fragment.search(".//stringProp[@name='JSON_PATH']").text).to eq ".key"
          expect(fragment.search(".//boolProp[@name='JSONVALIDATION']").text).to eq "true"
        end
      end
    end
  end
end
