require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "#constant_throughput_timer" do
    let(:test_plan) do
      JmeterPerf.test do
        threads do
          constant_throughput_timer value: 60.0
          constant_throughput_timer throughput: 70.0
        end
      end
    end

    it "should match on throughput using value" do
      expect(doc.search('//ConstantThroughputTimer[1]/stringProp[@name="throughput"]').first.content).to eq "60.0"
    end

    it "should match on throughput using throughput" do
      expect(doc.search('//ConstantThroughputTimer[2]/stringProp[@name="throughput"]').first.content).to eq "70.0"
    end
  end
end
