# frozen_string_literal: true

module Bpm
  module ElementExtractor
    class Sentence
      def initialize(sentence)
        @sentence = sentence
      end
    
      def activities
        binding.pry
        return [] unless @sentence.has_verb?

        matches = Bpm::ElementExtractor::Regex::Activity::REGEXES.map do |regex_rule|
          regex_rule.matches_for(@sentence)
        end.flatten(1)

        Utilities::MatchList.new(matches).without_duplicates
      end

      def events
        return [] unless @sentence.has_verb?
  
        matches = Bpm::ElementExtractor::Regex::Event::REGEXES.map do |regex_rule|
          regex_rule.matches_for(@sentence)
        end.flatten(1)
  
        Utilities::MatchList.new(matches).without_duplicates
      end

      def exclusive_gateways
        return [] unless @sentence.has_verb?
  
        matches = Bpm::ElementExtractor::Regex::ExclusiveGateway::REGEXES.map do |regex_rule|
          regex_rule.matches_for(@sentence)
        end.flatten(1)
  
        Utilities::MatchList.new(matches).without_duplicates
      end
    end
  end
end

