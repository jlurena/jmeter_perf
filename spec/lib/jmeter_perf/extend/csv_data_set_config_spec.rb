require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "#csv_data_set_config" do
    let(:test_plan) do
      JmeterPerf.test do
        csv_data_set_config delimiter: "|",
          filename: "test.csv",
          ignoreFirstLine: true,
          variableNames: "test1,test2"
      end
    end

    let(:csv_data_set) { doc.search("//CSVDataSet") }

    it "should match on variableNames" do
      expect(csv_data_set.search(".//stringProp[@name='variableNames']").first.text).to eq "test1,test2"
    end

    it "should match on delimiter" do
      expect(csv_data_set.search(".//stringProp[@name='delimiter']").first.text).to eq "|"
    end

    it "should match on filename" do
      expect(csv_data_set.search(".//stringProp[@name='filename']").first.text).to eq "test.csv"
    end

    it "should match on ignoreFirstLine" do
      expect(csv_data_set.search(".//boolProp[@name='ignoreFirstLine']").first.text).to eq "true"
    end
  end
end
