# frozen_string_literal: true

class SentenceActivityIdentifier
  def initialize(sentence)
    @sentence = sentence
  end

  def activities
    regex_matches
  end

  def regex_matches
    SentenceBpmRegexes.new(@sentence, ActivitiesRegexes::ACTIVITIES).matches
  end
end

class SentenceBpmRegexes
  def initialize(sentence, regexes)
    @sentence = sentence
    @regexes = regexes
  end

  def matches
    parts_of_speech_matches +
      parser_parts_of_speech_matches +
      parser_dependencies_matches
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
    []
  end
end

module ActivitiesRegexes
  VERB = /(VB)(D|G|N|P|Z)?/
  VERB_PRESENT = /(VB)/
  VERB_NOT_PAST = /(VB)(D|G|N|Z)?/
  VERB_PAST = /(VB)(P)?/
  MODIFIED_VERB = /(MD) #{VERB}/
  OBJECT = /((NN)(PS|P|S)?)/
  SUBJECT = /((NN)(PS|P|S)?)/
  CONNECTORS = /(\s?[!-z]*\s?)/
  VERB_AND_OBJECT = /(#{VERB_NOT_PAST}#{CONNECTORS}{0,2}#{OBJECT})/
  ACTIVITIES = [
    /(#{SUBJECT}#{CONNECTORS}{0,2}#{VERB_AND_OBJECT})/, # Rule 1
    /(#{SUBJECT}#{CONNECTORS}{0,2}#{MODIFIED_VERB}#{CONNECTORS}{0,2}#{OBJECT})/, # Rule 2
    /(#{VERB_AND_OBJECT})/, # Rule 3
    /(#{SUBJECT}#{CONNECTORS}{0,2}#{VERB_AND_OBJECT}#{CONNECTORS}{0,2}#{VERB_AND_OBJECT})/, # Rule 4
    /(#{OBJECT}#{CONNECTORS}{0,2}#{SUBJECT}#{CONNECTORS}{0,2}#{VERB_NOT_PAST})/, # Rule 5
    /(#{CONNECTORS}{0,2}#{VERB_AND_OBJECT}#{CONNECTORS}{0,2}#{VERB_AND_OBJECT})/ # Rule 6
  ]
end
