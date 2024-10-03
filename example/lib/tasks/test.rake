require "jmeter_perf"

namespace :test do
  desc "Runs performance tests"
  task performance: :environment do
    port = 3301
    puts "Starting Rails server on port #{port}"
    pid = Process.spawn("bundle exec rails server -p #{port}", out: File::NULL, err: $stderr)
    Process.detach(pid)
    sleep 5

    summaries = ["fast", "random", "slow"].map do |action|
      JmeterPerf.test do
        threads count: 2, duration: 10 do
          get(
            name: "#{action} action",
            url: "http://127.0.0.1:#{port}/test/#{action}"
          )
        end
      end.run(
        name: action,
        out_jmx: "tmp/#{action}.jmx",
        out_jmeter_log: "tmp/#{action}.log",
        out_jtl: "tmp/#{action}.jtl",
        out_cmd_log: "tmp/#{action}_cmd.log"
      )
    end

    base_summary = summaries.shift
    comparator = JmeterPerf::Report::Comparator.new(base_summary, base_summary, "#{base_summary.name}_vs_#{base_summary.name}")
    comparator.generate_reports(output_dir: "tmp")
    summaries.each do |summary|
      comparator = JmeterPerf::Report::Comparator.new(base_summary, summary, "#{base_summary.name}_vs_#{summary.name}")
      comparator.generate_reports(output_dir: "tmp")
    end

  ensure
    Process.kill("TERM", pid)
    puts "Rails server stopped."
  end
end
