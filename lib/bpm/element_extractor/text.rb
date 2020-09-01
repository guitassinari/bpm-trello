# frozen_string_literal: true

module Bpm
  module ElementExtractor
    class Text
      def initialize(string)
        @string = string
      end
    
      def activities
        unique_activities_phrases
      end
    
      private
    
      def unique_activities_phrases
        result = []
        sentences_activities_matches.each do |match|
          phrase = match.to_s
          match_group = [match]
          sentences_activities_matches.each do |other_match|
            other_phrase = other_match.to_s
            next unless other_phrase != phrase
            
            if other_phrase.include?(phrase) || phrase.include?(other_phrase)
              match_group.push(other_match)
            end
          end
          
          main_match = match_group.uniq(&:string).sort_by(&:length).last
          result.push(main_match)
        end
    
        result.uniq.reject(&:blank?)
      end
    
      def sentences_activities_matches
        @sentences_activities_matches ||=
          text.sentences_objects.map do |sentence|
            ElementExtractor::Sentence.new(sentence).activities
          end.flatten
      end
    
      def text
        @text ||= begin
          preprocessed = Preprocess::Text.new(@string)
                                         .add_period_if_needed
                                         .remove_parenthesis
                                         .substitute_coreferences
                                         .remove_stopwords
                                         .to_s
          StanfordCore::Text.new(preprocessed)
        end
      end
    end    
  end
end
