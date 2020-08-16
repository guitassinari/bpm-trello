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
        sentences_activities.each do |phrase|
          phrase_group = [phrase]
          sentences_activities.each do |other_phrase|
            next unless other_phrase != phrase
            
            if other_phrase.include?(phrase) || phrase.include?(other_phrase)
              phrase_group.push(other_phrase)
            end
          end
          
          
          main_phrase = phrase_group.uniq.sort_by(&:length).first
          result.push(main_phrase)
        end
    
        result.uniq.map do |a|
          Preprocess::Text.new(a).lemmatize_verbs.to_s
        end.reject(&:blank?)
      end
    
      def sentences_activities
        @sentences_activities ||=
          text.sentences_objects.map do |sentence|
            sentence_activities(sentence)
          end.flatten
      end
    
      def sentence_activities(sentence)
        ElementExtractor::Sentence.new(sentence).activities
      end
    
      def text
        @text ||= begin
          preprocessed = Preprocess::Text.new(@string)
                                         .lowercase
                                         .substitute_coreferences
                                         .remove_determiners.to_s
          StanfordCore::Text.new(preprocessed)
        end
      end
    end    
  end
end
