# frozen_string_literal: true

class SentencePosRegexApplier
  include PosRegexApplier

  def initialize(sentence, regex)
    @sentence = sentence
    @regex = regex
  end

  def matches
    matches_by_parser_tags + matches_by_regular_tags
  end

  def matches_by_regular_tags
    find_matches_by_tag_list(regular_tag_list)
  end

  def matches_by_parser_tags
    find_matches_by_tag_list(parser_tag_list)
  end

  private

  def regular_tag_list
    @sentence.parts_of_speech
  end

  def parser_tag_list
    semantic_graph.pos_tags
  end

  def semantic_graph
    @sentence.semantic_graph
  end

  def find_matches_by_tag_list(pos_tags_list)
    matches_token_ranges = token_ranges_for_matches(pos_tags_list.join(' '), @regex)
    matches_token_ranges.map do |range|
      begins_at, ends_at = range
      @sentence.tokens
               .slice(begins_at..ends_at)
               .join(' ')
               .remove(".")
               .remove(",")
               .strip
    end
  end
end