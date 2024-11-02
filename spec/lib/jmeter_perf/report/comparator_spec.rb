require "spec_helper"

RSpec.describe JmeterPerf::Report::Comparator do
  let(:base_report) { instance_double("Summary", avg: 100.0, std: 15.0, total_requests: 1000) }
  let(:test_report) { instance_double("Summary", avg: 120.0, std: 20.0, total_requests: 1000) }
  let(:name) { "comparison_test" }
  let(:comparator) { described_class.new(base_report, test_report, name) }
  let(:generator_class) { JmeterPerf::Report::Comparator.const_get(:Generator) }

  describe "#initialize" do
    it "initializes with base and test reports" do
      expect(comparator.instance_variable_get(:@base_report)).to eq(base_report)
      expect(comparator.instance_variable_get(:@test_report)).to eq(test_report)
      expect(comparator.name).to eq("comparison_test")
    end

    it "calculates Cohen's D and T-statistic" do
      expect(comparator.cohens_d).to be_a(Float)
      expect(comparator.t_statistic).to be_a(Float)
    end

    it "sets a human-readable rating" do
      expect(comparator.human_rating).to be_a(String)
    end
  end

  describe "#pass?" do
    context "with positive direction" do
      it "returns true if Cohen's D is greater than or equal to the limit" do
        allow(comparator).to receive(:cohens_d).and_return(0.3)
        expect(comparator.pass?(cohens_d_limit: 0.2, direction: :positive)).to be true
      end

      it "returns false if Cohen's D is less than the limit" do
        allow(comparator).to receive(:cohens_d).and_return(0.1)
        expect(comparator.pass?(cohens_d_limit: 0.2, direction: :positive)).to be false
      end
    end

    context "with negative direction" do
      it "returns true if Cohen's D is less than or equal to the negative limit" do
        allow(comparator).to receive(:cohens_d).and_return(-0.3)
        expect(comparator.pass?(cohens_d_limit: 0.2, direction: :negative)).to be true
      end

      it "returns false if Cohen's D is greater than the negative limit" do
        allow(comparator).to receive(:cohens_d).and_return(-0.1)
        expect(comparator.pass?(cohens_d_limit: 0.2, direction: :negative)).to be false
      end
    end

    context "with invalid direction" do
      it "raises an error" do
        expect { comparator.pass?(direction: :invalid) }.to raise_error(ArgumentError)
      end
    end

    context "with invalid effect size" do
      it "raises an error" do
        expect { comparator.pass?(effect_size: :invalid) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#generate_reports" do
    let(:generator) { instance_double(generator_class) }

    before do
      allow(generator_class).to receive(:new).and_return(generator)
    end

    it "generates both HTML and CSV reports with :all format" do
      expect(generator).to receive(:generate_report).with("./comparison_test_comparison_report.html", :html)
      expect(generator).to receive(:generate_report).with("./comparison_test_comparison_report.csv", :csv)
      comparator.generate_reports(output_dir: ".", output_format: :all)
    end

    it "generates only HTML report with :html format" do
      expect(generator).to receive(:generate_report).with("./comparison_test_comparison_report.html", :html)
      comparator.generate_reports(output_dir: ".", output_format: :html)
    end

    it "raises an error for invalid output format" do
      expect { comparator.generate_reports(output_format: :invalid) }.to raise_error(ArgumentError)
    end
  end
end
