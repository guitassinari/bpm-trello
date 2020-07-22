module PosRegexApplier
  def token_ranges_for_matches(pos_string, regex)
    scan_for_matches(pos_string, regex).map do |pos_sub_string|
      position_range_of_substring(pos_sub_string, pos_string)
    end
  end

  def scan_for_matches(pos_string, regex)
    pos_string.scan(regex).map(&:first)
  end

  def position_range_of_substring(sub_string, string)
    begins_at = string.index(sub_string)
    begins_at_token = string.slice(0, begins_at).count(' ')
    number_of_tokens = sub_string.split(' ').size
    ends_at_token = begins_at_token+number_of_tokens
    [begins_at_token, ends_at_token]
  end
end