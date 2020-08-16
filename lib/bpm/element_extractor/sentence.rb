# frozen_string_literal: true

module Bpm
  module ElementExtractor
    class Sentence
      def initialize(sentence)
        @sentence = sentence
      end
    
      def activities
        return [] unless @sentence.has_verb?

        SentenceBpmRegexesApplier
          .new(
            @sentence,
            Bpm::ElementExtractor::Regex::Activity::REGEXES
          ).matches
      end
    end
  end
end

class SentenceBpmRegexesApplier
  def initialize(sentence, regexes)
    @sentence = sentence
    @regexes = regexes
  end

  def matches
    parts_of_speech_matches +
      parser_parts_of_speech_matches
      # parser_dependencies_matches
  end

  def parts_of_speech_matches
    @regexes.map do |regex|
      SentencePosRegexApplier.new(@sentence, regex).matches_by_regular_tags
    end.flatten(1)
  end

  def parser_parts_of_speech_matches
    @regexes.map do |regex|
      SentencePosRegexApplier.new(@sentence, regex).matches_by_parser_tags
    end.flatten(1)
  end

  def parser_dependencies_matches
    # ["root", "dobj", "nn"]
    # ["root", "dobj", "amod"]
    # Assumir que root é verbo. Begar objeto. Sujeito?
    SentenceDependenciesRegexApplier.new(@sentence, REGEX_1).matches
  end
end

module SentenceRegexApplier
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

class SentenceDependenciesRegexApplier
  include SentenceRegexApplier

  def initialize(sentence, regex)
    @sentence = sentence
    @regex = regex
  end

  def matches
    matches_token_ranges = token_ranges_for_matches(dependencies_string, @regex)
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

  def dependencies_string
    @sentence.semantic_graph.relations.join(' ')
  end
end

class SentencePosRegexApplier
  include SentenceRegexApplier

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