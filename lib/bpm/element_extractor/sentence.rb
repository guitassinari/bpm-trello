# frozen_string_literal: true

module Bpm
  module ElementExtractor
    class Sentence
      def initialize(sentence)
        @sentence = sentence
      end
    
      def activities
        return [] unless @sentence.has_verb?

        Bpm::ElementExtractor::Regex::Activity::REGEXES.map do |regex_rule|
          Bpm::ElementExtractor::Utilities::SentencePosRegexApplier
            .new(@sentence, regex_rule)
            .matches
        end.flatten(1)
      end
    end
  end
end

