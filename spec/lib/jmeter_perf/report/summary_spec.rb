require "spec_helper"
require "fileutils"

TEST_TMP_DIR = "tmp/summary_tests".freeze

RSpec.describe JmeterPerf::Report::Summary do
  let(:file_path) { "#{TEST_TMP_DIR}/test.jtl" }
  let(:output_file) { "#{TEST_TMP_DIR}/output_report.csv" }
  let(:summary) { described_class.new(file_path: file_path) }

  before(:all) do
    FileUtils.mkdir_p(TEST_TMP_DIR) # Ensure the test-specific tmp directory exists
  end

  after(:all) do
    FileUtils.rm_rf(TEST_TMP_DIR) # Clean up the test-specific tmp directory after all tests
  end

  describe ".read" do
    before do
      File.open(output_file, "w") do |file|
        file.puts "Metric,Value"
        file.puts "Average Response Time,300.0"
        file.puts "Error Percentage,5.0"
        file.puts "Max Response Time,1000"
        file.puts "Min Response Time,100"
        file.puts "10th Percentile,150.0"
        file.puts "Median (50th Percentile),300.0"
        file.puts "95th Percentile,900.0"
        file.puts "Requests Per Minute,120.0"
        file.puts "Standard Deviation,20.0"
        file.puts "Total Bytes,4096"
        file.puts "Total Errors,5"
        file.puts "Total Latency,2000"
        file.puts "Total Requests,100"
        file.puts "Total Sent Bytes,2048"
        file.puts "Response Code 200,95"
        file.puts "Response Code 500,5"
        file.puts "CSV Errors,5:10"
      end
    end

    it "reads the CSV report and sets the appropriate attributes" do
      summary = described_class.read(output_file)

      expect(summary.avg).to eq(300.0)
      expect(summary.error_percentage).to eq(5.0)
      expect(summary.max).to eq(1000)
      expect(summary.min).to eq(100)
      expect(summary.p10).to eq(150.0)
      expect(summary.p50).to eq(300.0)
      expect(summary.p95).to eq(900.0)
      expect(summary.requests_per_minute).to eq(120.0)
      expect(summary.standard_deviation).to eq(20.0)
      expect(summary.total_bytes).to eq(4096)
      expect(summary.total_errors).to eq(5)
      expect(summary.total_latency).to eq(2000)
      expect(summary.total_requests).to eq(100)
      expect(summary.total_sent_bytes).to eq(2048)
      expect(summary.response_codes).to eq({"200" => 95, "500" => 5})
      expect(summary.csv_error_lines).to eq([5, 10])
    end
  end

  describe "#initialize" do
    it "sets the name based on the file path if no name is provided" do
      expect(summary.name).to eq(file_path.tr("/", "_"))
    end

    it "initializes the response codes as an empty hash" do
      expect(summary.response_codes).to eq({})
    end

    it "initializes total bytes, elapsed time, errors, latency, requests, and sent bytes to zero" do
      expect(summary.total_bytes).to eq(0)
      expect(summary.total_errors).to eq(0)
      expect(summary.total_latency).to eq(0)
      expect(summary.total_requests).to eq(0)
      expect(summary.total_sent_bytes).to eq(0)
    end
  end

  describe "#write_csv" do
    it "generates a file with the summary metrics and response codes" do
      summary.response_codes = {"200" => 95, "500" => 5}
      summary.write_csv(output_file)

      expect(File.read(output_file).split("\n")).to eq(
        <<~CSV.split("\n")
          Metric,Value
          Name,tmp_summary_tests_test.jtl
          Average Response Time,
          Error Percentage,
          Max Response Time,0
          Min Response Time,1000000
          10th Percentile,
          Median (50th Percentile),
          95th Percentile,
          Requests Per Minute,
          Standard Deviation,
          Total Run Time,
          Total Bytes,0
          Total Errors,0
          Total Latency,0
          Total Requests,0
          Total Sent Bytes,0
          Response Code 200,95
          Response Code 500,5
          CSV Errors,""

        CSV
      )
    end
  end

  describe "#stream_jtl_async" do
    it "reads a file as it is being written into asynchronously and skips the header line" do
      # Initialize the attributes to track changes made by the stream
      summary.total_requests = 0
      summary.total_errors = 0
      summary.total_bytes = 0

      # Start the async reading in a separate thread
      summary.stream_jtl_async

      # Simulate writing to the file in chunks
      Thread.new do
        File.open(file_path, "w") do |file|
          file.puts "timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,URL,Latency,IdleTime,Connect" # Header line
          file.write "#{Time.now.to_i * 1000},100,label,200,OK,thread1,text,true,,1024,512,1,2,http://test.com,20,0,10"
          sleep 1
          file.write "\n" # Complete last line
          file.puts "#{Time.now.to_i * 1000},100,label,200,OK,thread1,text,true,,1024,512,1,2,http://test.com,20,0,10"
          sleep 0.2
          file.puts "#{Time.now.to_i * 1000},300,label,500,Error,thread2,text,false,timeout,2048,1024,1,2,http://test.com,30,0,15"
          # Imitate incomplete line that looks like bad CSV
          file.write "#{Time.now.to_i * 1000},200,label,200,OK,thread3,text,true,,1024,512,1,2,\"http://test.com"
          sleep 0.5
          file.write "\",25,0,12\n" # Complete last line
          file.puts "\"bad csv line,"
        end
        summary.finish! # Signal processing completion
      end.join

      # Verify the results after processing is guaranteed to be complete
      expect(summary.total_requests).to eq(4)
      expect(summary.total_errors).to eq(1)
      expect(summary.total_bytes).to eq(5120)
      expect(summary.csv_error_lines).to eq([6])
    end
  end

  describe "#summarize_data!" do
    before do
      allow(summary.instance_variable_get(:@running_statistics_helper)).to receive(:get_percentiles).and_return([10.0, 50.0, 95.0])
      allow(summary.instance_variable_get(:@running_statistics_helper)).to receive(:avg).and_return(300.0)
      allow(summary.instance_variable_get(:@running_statistics_helper)).to receive(:std).and_return(20.0)

      summary.total_errors = 5
      summary.total_requests = 100
      summary.instance_variable_set(:@start_time, 0)
      summary.instance_variable_set(:@end_time, 5 * 60 * 1000)
    end

    it "calculates error percentage, average, percentiles, and requests per minute" do
      summary.summarize_data!

      expect(summary.error_percentage).to eq(5.0)
      expect(summary.avg).to eq(300.0)
      expect(summary.p10).to eq(10.0)
      expect(summary.p50).to eq(50.0)
      expect(summary.p95).to eq(95.0)
      expect(summary.requests_per_minute).to eq(20.0)
      expect(summary.standard_deviation).to eq(20.0)
    end
  end
end
