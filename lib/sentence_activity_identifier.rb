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
    find_activities_by_pos_tags(@sentence.parts_of_speech)
  end

  def parser_parts_of_speech_activities
    find_activities_by_pos_tags(semantic_graph.pos_tags)
  end

  def parser_activities
    []
  end

  def semantic_graph
    @sentence.semantic_graph
  end

  def find_activities_by_pos_tags(pos_tags_list)
    activities_tokens_ranges = find_activities_matches_in_pos_string(pos_tags_list.join(' '))
    activities_tokens_ranges.map do |range|
      begins_at, ends_at = range 
      @sentence.tokens.slice(begins_at..ends_at).join(' ')
    end
  end

  def find_activities_matches_in_pos_string(pos_string)
    ActivitiesRegexes::ACTIVITIES.map do |regex|
      matches = pos_string.scan(regex)
      matches.map(&:first).map do |pos_sub_string|
        tokens_range_by_parts_of_speech(pos_sub_string, pos_string)
      end
    end.flatten(1)
  end

  def tokens_range_by_parts_of_speech(pos_string, sentence_pos_string)
    index_of_substring = sentence_pos_string.index(pos_string)   # finds where pos_string is inside sentence_pos_string
    number_of_tokens = pos_string.split(' ').size                # number of tokens in pos string
    first_token_index = sentence_pos_string.slice(0, index_of_substring).count(' ')  # finds in which token pos_string begins in sentence_pos_string
    [first_token_index, first_token_index+number_of_tokens]
  end

  def teste
    parts_of_speech_activities + parser_activities
  end
end

class Expression < StanfordCore::NlpWrapper
  def id
    value.to_s
  end

  private

  def value
    send_nlp(:value)
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