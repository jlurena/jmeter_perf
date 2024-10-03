module JmeterPerf::Report
  class Comparator
    attr_reader :cohens_d, :t_statistic, :human_rating, :name

    EFFECT_SIZE_LIMITS = {
      vsmall: 0.01,  # very small
      small: 0.2,    # small
      medium: 0.5,   # medium
      large: 0.8,    # large
      vlarge: 1.2,   # very large
      huge: 2.0      # huge
    }

    EFFECT_SIZE_DIRECTION = %i[positive negative both]

    def initialize(base_report, test_report, name = nil)
      @base_report = base_report
      @test_report = test_report
      @name = name
      compare_reports!
    end

    def pass?(cohens_d_limit = nil, effect_size = :vsmall, direction = :both)
      # Mapping effect size symbols to Cohen's D values

      # Validate effect size and get Cohen's D limit
      limit = cohens_d_limit || EFFECT_SIZE_LIMITS[effect_size]
      raise ArgumentError, "Invalid effect size: #{effect_size}" unless cohens_d_limit

      # Validate direction
      raise ArgumentError, "Invalid direction: #{direction}" unless EFFECT_SIZE_DIRECTION.include?(direction)

      case direction
      when :positive
        cohens_d >= limit
      when :negative
        cohens_d <= -limit
      when :both
        if cohens_d >= limit
          true
        else
          !(cohens_d <= -limit)
        end
      end
    end

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

    def calc_cohens_d(mean1, mean2, sd1, sd2)
      mean_diff = mean1 - mean2
      pooled_sd = Math.sqrt((sd1**2 + sd2**2) / 2.0)
      mean_diff / pooled_sd
    end

    def calc_t_statistic(mean1, mean2, sd1, sd2, n2)
      numerator = mean1 - mean2
      denominator = Math.sqrt((sd1**2 + sd2**2) / n2)
      numerator / denominator
    end

    def set_diff_rating
      # 1. Get direction of movement
      s_dir = "change"
      s_dir = "decrease" if cohens_d < 0
      s_dir = "increase" if cohens_d > 0

      # 2. Get magnitude of movement according to Sawilowsky's rule of thumb
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

    class Generator
      def initialize(comparator, reports)
        @comparator = comparator
        @reports = reports
      end

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

      private

      def generate_html_report(output_path)
        template_path = File.join(__dir__, "..", "views", "report_template.html.erb")
        template = File.read(template_path)
        result = ERB.new(template).result(binding)
        File.write(output_path, result)
      end

      def generate_csv_report(output_path)
        CSV.open(output_path, "wb") do |csv|
          csv << ["Label", "Requests", "Errors", "Error %", "Min", "Median", "Avg", "Max", "Std", "P10", "P50", "P95"]

          @reports.each_with_index do |report, index|
            csv << [
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
            ]
          end
        end
      end

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

      def format_line(values)
        values.map { |v| v.to_s.ljust(10) }.join(" ") + "\n"
      end
    end

    private_constant :Generator
  end
end
