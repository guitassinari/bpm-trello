# frozen_string_literal: true

class SentenceActivityIdentifier
  def initialize(sentence)
    @sentence = sentence
  end

  def activity

  end

  def has_activity?
    return false unless @sentence.has_verb?
  end

  def parts_of_speech_activities
    ActivitiesRegexes::ACTIVITIES.map do |regex|
      SentencePosRegexApplier.new(@sentence, regex).matches_by_regular_tags
    end.flatten(1)
  end

  def parser_parts_of_speech_activities
    ActivitiesRegexes::ACTIVITIES.map do |regex|
      SentencePosRegexApplier.new(@sentence, regex).matches_by_parser_tags
    end.flatten(1)
  end

  def teste
    parts_of_speech_activities + parser_parts_of_speech_activities
  end
end

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

class SentencePosRegexApplier
  include ::PosRegexApplier

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
      @sentence.tokens.slice(begins_at..ends_at).join(' ')
    end
  end
end



module ActivitiesRegexes
  VERB = /(VB)(D|G|N|P|Z)?/
  VERB_PRESENT = /(VB)/
  VERB_NOT_PAST = /(VB)(D|G|N|Z)?/
  VERB_PAST = /(VB)(P)?/
  MODIFIED_VERB = /(MD) #{VERB}/

  OBJECT = /(NN(PS|P|S)?)/
  SUBJECT = /(NN(PS|P|S)?)/
  CONNECTORS = /(\s?[!-z]*\s?)/
  VERB_AND_OBJECT = /(#{VERB_NOT_PAST}#{CONNECTORS}{0,3}#{OBJECT})/
  ACTIVITIES = [
    /(#{SUBJECT}#{CONNECTORS}{0,3}#{VERB_AND_OBJECT})/, # Rule 1
    /(#{SUBJECT}#{CONNECTORS}{0,3}#{MODIFIED_VERB}#{CONNECTORS}{0,3}#{OBJECT})/, # Rule 2
    /(#{VERB_AND_OBJECT})/, # Rule 3
    /(#{SUBJECT}#{CONNECTORS}{0,3}#{VERB_AND_OBJECT}#{CONNECTORS}{0,3}#{VERB_AND_OBJECT})/, # Rule 4
    /(#{OBJECT}#{CONNECTORS}{0,3}#{SUBJECT}#{CONNECTORS}{0,3}#{VERB_NOT_PAST})/, # Rule 5
    /(#{CONNECTORS}{0,3}#{VERB_AND_OBJECT}#{CONNECTORS}{0,3}#{VERB_AND_OBJECT})/ # Rule 6
  ]
end


# (NN(PS|P|S)?)(\s?[!-z]\s?){0,5}(VB(D|G|N|P|Z)?)(\s?[!-z]\s?){0,5}(NN(PS|P|S)?)
# (NN(PS|P|S)?)(\s?[!-z]*\s?){0,5}(VB(D|G|N|P|Z)?)(\s?[!-z]*\s?){0,5}(NN(PS|P|S)?)