require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "#extract" do
    context "json" do
      let(:test_plan) do
        JmeterPerf.test do
          extract json: ".test.path", name: "my_json"
        end
      end

      let(:fragment) { doc.search("//com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor").first }

      it "should match on json path and match on json var" do
        expect(fragment.search(".//stringProp[@name='JSONPATH']").text).to eq ".test.path"
        expect(fragment.search(".//stringProp[@name='VAR']").text).to eq "my_json"
      end
    end
  end
end
