module JmeterPerf
  module Report
    # Comparator performs statistical comparison between two performance reports.
    # It calculates metrics like Cohen's D and T-statistic to measure the effect size
    # and generates comparison reports in various formats.
    class Comparator
      # @return [Float] the calculated Cohen's D value
      # @see https://en.wikipedia.org/wiki/Effect_size#Cohen's_d
      attr_reader :cohens_d
      # @return [Float] the calculated T-statistic value
      # @see https://en.wikipedia.org/wiki/Student%27s_t-test
      attr_reader :t_statistic
      # @return [String] a human-readable rating of the comparison result
      attr_reader :human_rating
      # @return [String] the name of the comparison, if provided
      attr_reader :name

      # Effect size thresholds according to Sawilowsky's rule of thumb
      EFFECT_SIZE_LIMITS = {
        vsmall: 0.01,  # very small
        small: 0.2,    # small
        medium: 0.5,   # medium
        large: 0.8,    # large
        vlarge: 1.2,   # very large
        huge: 2.0      # huge
      }

      # Valid effect size directions.
      #   `positive` means the test report is better than the base report.
      #   `negative` means the test report is worse than the base report.
      EFFECT_SIZE_DIRECTION = %i[positive negative both]
      COMPARISON_REPORT_HEADER = [
        "Label",
        "Total Requests",
        "Total Elapsed Time",
        "RPM",
        "Errors",
        "Error %",
        "Min",
        "Max",
        "Avg",
        "SD",
        "P10",
        "P50",
        "P95"
      ]

      # Initializes a Comparator instance to compare two reports.
      #
      # @param base_report [Summary] the base performance report
      # @param test_report [Summary] the test performance report
      # @param name [String, nil] an optional name for the comparison (default: nil)
      def initialize(base_report, test_report, name = nil)
        @base_report = base_report
        @test_report = test_report
        @name = name&.gsub(/\s+/, "_")
        compare_reports!
      end

      # Checks if the comparison passes based on Cohen's D and effect size.
      # @note If no Cohen's D limit is provided, the `effect_size` threshold is used.
      # @param cohens_d_limit [Float, nil] optional limit for Cohen's D (default: nil)
      # @param effect_size [Symbol] the desired effect size threshold (default: :vsmall).
      #   See {JmeterPerf::Report::Comparator::EFFECT_SIZE_LIMITS} for options.
      # @param direction [Symbol] the direction of comparison, e.g., :positive (default: :negative)
      #   See {JmeterPerf::Report::Comparator::EFFECT_SIZE_DIRECTION} for options.
      # @raise [ArgumentError] if the effect size or direction is invalid
      # @return [Boolean] true if comparison meets the criteria
      def pass?(cohens_d_limit: nil, effect_size: :vsmall, direction: :positive)
        limit = cohens_d_limit || EFFECT_SIZE_LIMITS[effect_size]
        raise ArgumentError, "Invalid effect size: #{effect_size}" unless limit
        raise ArgumentError, "Invalid direction: #{direction}" unless EFFECT_SIZE_DIRECTION.include?(direction)

        case direction
        when :positive
          cohens_d >= limit
        when :negative
          cohens_d <= -limit
        end
      end

      # Generates comparison reports in specified formats.
      #
      # @param output_dir [String] the directory for output files (default: ".")
      # @param output_format [Symbol] the format for the report, e.g., :html, :csv (default: :all)
      # @raise [ArgumentError] if the output format is invalid
      # @return [void]
      def generate_reports(output_dir: ".", output_format: :all)
        generator = Generator.new(self, [@base_report, @test_report])

        case output_format
        when :all
          generator.generate_report(File.join(output_dir, "#{@name}_comparison_report.html"), :html)
          generator.generate_report(File.join(output_dir, "#{@name}_comparison_report.csv"), :csv)
        when :html, :csv
          generator.generate_report(File.join(output_dir, "#{@name}_comparison_report.#{output_format}"), output_format)
        else
          raise ArgumentError, "Invalid output format: #{output_format}"
        end
      end

      private

      # Calculates Cohen's D and T-statistic between the two reports.
      #
      # @return [void]
      def compare_reports!
        @cohens_d = calc_cohens_d(@base_report.avg, @test_report.avg, @base_report.std, @test_report.std).round(2)
        @t_statistic = calc_t_statistic(
          @base_report.avg,
          @test_report.avg,
          @base_report.std,
          @test_report.std,
          @test_report.total_requests
        ).round(2)

        set_diff_rating
      end

      # Calculates Cohen's D between two means with given standard deviations.
      #
      # @param mean1 [Float] mean of the base report
      # @param mean2 [Float] mean of the test report
      # @param sd1 [Float] standard deviation of the base report
      # @param sd2 [Float] standard deviation of the test report
      # @return [Float] calculated Cohen's D
      def calc_cohens_d(mean1, mean2, sd1, sd2)
        mean_diff = mean1 - mean2
        pooled_sd = Math.sqrt((sd1**2 + sd2**2) / 2.0)
        mean_diff / pooled_sd
      end

      # Calculates T-statistic between two means with given standard deviations and sample size.
      #
      # @param mean1 [Float] mean of the base report
      # @param mean2 [Float] mean of the test report
      # @param sd1 [Float] standard deviation of the base report
      # @param sd2 [Float] standard deviation of the test report
      # @param n2 [Integer] sample size of the test report
      # @return [Float] calculated T-statistic
      def calc_t_statistic(mean1, mean2, sd1, sd2, n2)
        numerator = mean1 - mean2
        denominator = Math.sqrt((sd1**2 + sd2**2) / n2)
        numerator / denominator
      end

      # Sets a human-readable rating for the difference between reports.
      #
      # @return [void]
      def set_diff_rating
        s_dir = if cohens_d.positive?
          "increase"
        else
          cohens_d.negative? ? "decrease" : "change"
        end
        s_mag = case cohens_d.abs
        when 1.20...2.0 then "Very large"
        when 0.80...1.20 then "Large"
        when 0.50...0.80 then "Medium"
        when 0.02...0.50 then "Small"
        when 0.01...0.02 then "Very small"
        when 0.0...0.01 then "Negligible"
        else "Huge"
        end
        @human_rating = "#{s_mag} #{s_dir}"
      end

      # Generator is responsible for generating comparison reports in HTML and CSV formats.
      class Generator
        # Initializes a Generator instance to handle report generation.
        #
        # @param comparator [Comparator] the comparator instance
        # @param reports [Array<Summary>] an array of performance reports
        def initialize(comparator, reports)
          @comparator = comparator
          @reports = reports
        end

        # Prints a comparison report to standard output.
        #
        # @return [void]
        def print_comparison
          puts "Comparison Report"
          puts "-" * 90
          puts format_line(COMPARISON_REPORT_HEADER)
          puts "-" * 90
          @reports.each_with_index do |report, index|
            puts format_line([
              (index == 0) ? "Base Metric" : "Test Metric",
              report.total_requests,
              report.total_run_time,
              sprintf("%.2f", report.rpm),
              report.total_errors,
              sprintf("%.2f", report.error_percentage),
              report.min,
              report.max,
              sprintf("%.2f", report.avg),
              sprintf("%.2f", report.std),
              sprintf("%.2f", report.p10),
              sprintf("%.2f", report.p50),
              sprintf("%.2f", report.p95)
            ])
          end
        end

        # Generates a report in the specified format at the given path.
        #
        # @param output_path [String] the path to save the generated report
        # @param output_format [Symbol] the format for the report, e.g., :html or :csv
        # @return [void]
        def generate_report(output_path, output_format)
          case output_format
          when :html
            generate_html_report(output_path)
          when :csv
            generate_csv_report(output_path)
          else
            print_report(output_path)
          end
        end

        # Generates an HTML report.
        #
        # @param output_path [String] the path to save the HTML report
        # @return [void]
        def generate_html_report(output_path)
          template_path = File.join(__dir__, "..", "views", "report_template.html.erb")
          template = File.read(template_path)
          result = ERB.new(template).result(binding)
          File.write(output_path, result)
        end

        # Generates a CSV report.
        #
        # @param output_path [String] the path to save the CSV report
        # @return [void]
        def generate_csv_report(output_path)
          CSV.open(output_path, "wb") do |csv|
            csv << COMPARISON_REPORT_HEADER
            @reports.each_with_index do |report, index|
              csv << [
                (index == 0) ? "Base Metric" : "Test Metric",
                report.total_requests,
                report.total_run_time,
                sprintf("%.2f", report.rpm),
                report.total_errors,
                sprintf("%.2f", report.error_percentage),
                report.min,
                report.max,
                sprintf("%.2f", report.avg),
                sprintf("%.2f", report.std),
                sprintf("%.2f", report.p10),
                sprintf("%.2f", report.p50),
                sprintf("%.2f", report.p95)
              ]
            end
          end
        end

        # Prints a plain text version of the report to standard output.
        #
        # @param output_path [String] the path for plain text output
        # @return [void]
        def print_report(output_path)
          report_text = "Comparison Report\n\n"
          report_text << format_line(["Label", "Requests", "Errors", "Error %", "Min", "Median", "Avg", "Max", "Std", "P10", "P50", "P95"])
          report_text << "-" * 90 + "\n"
          @reports.each_with_index do |report, index|
            report_text << format_line([
              (index == 0) ? "Base Metric" : "Test Metric",
              report.total_requests,
              report.total_errors,
              sprintf("%.2f", report.error_percentage),
              report.min,
              report.median,
              sprintf("%.2f", report.avg),
              report.max,
              sprintf("%.2f", report.std),
              sprintf("%.2f", report.p10),
              sprintf("%.2f", report.p50),
              sprintf("%.2f", report.p95)
            ])
          end
          puts report_text
        end

        # Formats a line for plain text output.
        #
        # @param values [Array<String, Numeric>] the values to format
        # @return [String] the formatted line
        def format_line(values)
          values.map { |v| v.to_s.ljust(10) }.join(" ") + "\n"
        end
      end

      private_constant :Generator
    end
  end
end
