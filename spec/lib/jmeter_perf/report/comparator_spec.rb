require "spec_helper"
require "jmeter_perf/report/comparator"

RSpec.describe JmeterPerf::Report::Comparator do
  let(:base_report) do
    instance_double(
      "Summary",
      avg: 150.0,
      std: 25.0,
      total_requests: 1000,
      total_run_time: 1000,
      rpm: 120.0,
      total_errors: 5,
      error_percentage: 0.5,
      min: 100,
      max: 200,
      p10: 110.0,
      p50: 150.0,
      p95: 190.0
    )
  end

  let(:test_report) do
    instance_double(
      "Summary",
      avg: 160.0,
      std: 30.0,
      total_requests: 1200,
      total_run_time: 1200,
      rpm: 130.0,
      total_errors: 8,
      error_percentage: 0.67,
      min: 110,
      max: 210,
      p10: 115.0,
      p50: 160.0,
      p95: 200.0
    )
  end
  let(:name) { "comparison_test" }
  let(:comparator) { described_class.new(base_report, test_report, name) }
  let(:output_dir) { "tmp/" }

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
    it "sets the correct human-readable rating for various Cohen's D values", :aggregate_failures do
      ratings = {
        -0.8 => "Large decrease",
        -0.5 => "Medium decrease",
        -0.2 => "Small decrease",
        0.0 => "Negligible change",
        0.2 => "Small increase",
        0.5 => "Medium increase",
        0.8 => "Large increase"
      }

      ratings.each do |d_value, expected_rating|
        comparator.instance_variable_set(:@cohens_d, d_value)
        comparator.send(:set_diff_rating)
        expect(comparator.human_rating).to eq(expected_rating)
      end
    end
  end

  describe "#pass?" do
    context "when testing for impact" do
      it "returns true if Cohen's D is positive" do
        allow(comparator).to receive(:cohens_d).and_return(0.5)
        expect(comparator.pass?(effect_size: :vsmall)).to be true
      end

      it "returns true if Cohen's D is greater than or equal to the negative limit" do
        allow(comparator).to receive(:cohens_d).and_return(-0.01)
        expect(comparator.pass?(effect_size: :vsmall)).to be true
      end

      it "returns false if Cohen's D is less than the negative limit" do
        allow(comparator).to receive(:cohens_d).and_return(-0.5)
        expect(comparator.pass?(effect_size: :vsmall)).to be false
      end
    end

    context "with invalid effect size" do
      it "raises an error" do
        expect { comparator.pass?(effect_size: :invalid) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#generate_reports" do
    it "generates both HTML and CSV reports with :all format and checks contents" do
      expect {
        comparator.generate_reports(output_dir: output_dir, output_format: :all)
      }.to output.to_stdout

      html_report_path = File.join(output_dir, "comparison_test_comparison_report.html")
      csv_report_path = File.join(output_dir, "comparison_test_comparison_report.csv")

      expect(File).to exist(html_report_path)
      expect(File).to exist(csv_report_path)

      html_content = File.read(html_report_path)
      csv_content = File.read(csv_report_path)

      expect(html_content).to include("Comparison Report")
      expect(html_content).to include("<b>Cohen's D:</b> #{comparator.cohens_d}<br>")
      expect(html_content).to include("<b>Summary:</b> #{comparator.human_rating}")

      expect(csv_content).to include("Label,Total Requests,Total Elapsed Time,RPM,Errors,Error %,Min,Max,Avg,SD,P10,P50,P95")
      expect(csv_content).to include("Base Metric,1000,1000,120.00,5,0.50,100,200,150.00,25.00,110.00,150.00,190.00")
      expect(csv_content).to include("Test Metric,1200,1200,130.00,8,0.67,110,210,160.00,30.00,115.00,160.00,200.00")
    end

    it "generates only HTML report with :html format and checks contents" do
      comparator.generate_reports(output_dir: output_dir, output_format: :html)

      html_report_path = File.join(output_dir, "comparison_test_comparison_report.html")
      expect(File).to exist(html_report_path)

      html_content = File.read(html_report_path)
      expect(html_content).to include("Comparison Report")
      expect(html_content).to include("<b>Cohen's D:</b> #{comparator.cohens_d}<br>")
      expect(html_content).to include("<b>Summary:</b> #{comparator.human_rating}")
    end

    it "raises an error for invalid output format" do
      expect { comparator.generate_reports(output_format: :invalid) }.to raise_error(ArgumentError)
    end

    it "generates the report to stdout and matches the output" do
      expected_output = <<~OUTPUT
        Comparison Report
        Cohen's D: #{comparator.cohens_d}
        Human Rating: #{comparator.human_rating}
        ---------------------------------------------------------------------------------------------------------------------------------------
        Label           Total Requests    Total Elapsed Time    RPM      Errors   Error %   Min     Max     Avg      SD       P10      P50      P95
        ---------------------------------------------------------------------------------------------------------------------------------------
        Base Metric     1000              1000               120.00   5        0.50      100     200     150.00   25.00    110.00   150.00   190.00
        Test Metric     1200              1200               130.00   8        0.67      110     210     160.00   30.00    115.00   160.00   200.00
        ---------------------------------------------------------------------------------------------------------------------------------------
      OUTPUT

      allow(base_report).to receive_messages(total_requests: 1000, total_run_time: 1000, rpm: 120.0, total_errors: 5, error_percentage: 0.5, min: 100, max: 200, avg: 150.0, std: 25.0, p10: 110.0, p50: 150.0, p95: 190.0)
      allow(test_report).to receive_messages(total_requests: 1200, total_run_time: 1200, rpm: 130.0, total_errors: 8, error_percentage: 0.67, min: 110, max: 210, avg: 160.0, std: 30.0, p10: 115.0, p50: 160.0, p95: 200.0)

      actual_output = comparator.to_s.strip.gsub(/\s+/, " ")
      expected_output = expected_output.strip.gsub(/\s+/, " ")

      expect(actual_output).to eq(expected_output)
    end
  end

  describe "#to_s" do
    it "returns a string representation of the comparison report with Cohen's D and human rating" do
      expected_output = <<~OUTPUT
        Comparison Report
        Cohen's D: -0.36
        Human Rating: Small decrease
        ---------------------------------------------------------------------------------------------------------------------------------------
        Label           Total Requests    Total Elapsed Time    RPM      Errors   Error %   Min     Max     Avg      SD       P10      P50      P95
        ---------------------------------------------------------------------------------------------------------------------------------------
        Base Metric     1000              1000               120.00   5        0.50      100     200     150.00   25.00    110.00   150.00   190.00
        Test Metric     1200              1200               130.00   8        0.67      110     210     160.00   30.00    115.00   160.00   200.00
        ---------------------------------------------------------------------------------------------------------------------------------------
      OUTPUT

      allow(base_report).to receive_messages(total_requests: 1000, total_run_time: 1000, rpm: 120.0, total_errors: 5, error_percentage: 0.5, min: 100, max: 200, avg: 150.0, std: 25.0, p10: 110.0, p50: 150.0, p95: 190.0)
      allow(test_report).to receive_messages(total_requests: 1200, total_run_time: 1200, rpm: 130.0, total_errors: 8, error_percentage: 0.67, min: 110, max: 210, avg: 160.0, std: 30.0, p10: 115.0, p50: 160.0, p95: 200.0)

      actual_output = comparator.to_s.strip.gsub(/\s+/, " ")
      expected_output = expected_output.strip.gsub(/\s+/, " ")

      expect(actual_output).to eq(expected_output)
    end
  end
end
