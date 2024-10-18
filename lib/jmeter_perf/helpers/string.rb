class String
  def classify
    gsub(/\s/, "_").camelize
  end

  def underscore
    gsub("::", "/")
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr("-", "_")
      .downcase
  end

  def camelize(uppercase_first_letter = true)
    string = dup
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

  def strip_heredoc
    gsub(/^#{self[/\A\s*/]}/, "")
  end
end
