module JmeterPerf::Helpers
  class String
    class << self
      # Converts a string to CamelCase.
      #
      # @param string [String] the string to be converted.
      # @return [String] the CamelCase version of the string.
      def classify(string)
        camelize(string.gsub(/\s/, "_"))
      end

      # Converts a string to snake_case.
      #
      # @param string [String] the string to be converted.
      # @return [String] the snake_case version of the string.
      def underscore(string)
        string.gsub("::", "/")
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr("-", "_")
          .downcase
      end

      # Converts a string to CamelCase or camelCase.
      #
      # @param str [String] the string to be converted.
      # @param uppercase_first_letter [Boolean, Symbol] whether to capitalize the first letter or not.
      #   If `:lower`, the first letter will be lowercase.
      # @return [String] the CamelCase or camelCase version of the string.
      def camelize(str, uppercase_first_letter = true)
        string = str.dup
        # String#camelize takes a symbol (:upper or :lower), so here we also support :lower to keep the methods consistent.
        if !uppercase_first_letter || uppercase_first_letter == :lower
          string = string.sub(/^(?:(?=a)b(?=\b|[A-Z_])|\w)/) { |match| match.downcase! || match }
        elsif string.match?(/\A[a-z\d]*\z/)
          return string.capitalize
        else
          string = string.sub(/^[a-z\d]*/) { |match| match.capitalize || match }
        end

        string.gsub!(/(?:_|(\/))([a-z\d]*)/i) do
          word = $2
          substituted = word.capitalize! || word
          ($1) ? "_#{substituted}" : substituted
        end

        string.gsub!(/[^a-zA-Z0-9]/, "")
        string
      end

      # Strips leading whitespace from each line that is the same as the amount of whitespace on the first line.
      #
      # @param string [String] the string to be stripped of leading whitespace.
      # @return [String] the string with leading whitespace removed.
      def strip_heredoc(string)
        string.gsub(/^#{string[/\A\s*/]}/, "")
      end
    end
  end
end
