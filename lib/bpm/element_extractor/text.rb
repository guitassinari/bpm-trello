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

      def events
        unique_events_phrases
      end
    
      private
    
      def unique_activities_phrases
        Utilities::MatchList.new(sentences_activities_matches)
                            .without_duplicates
      end

      def unique_events_phrases
        Utilities::MatchList.new(sentences_events_matches)
                            .without_duplicates
      end
    
      def sentences_activities_matches
        @sentences_activities_matches ||=
          text.sentences_objects.map do |sentence|
            ElementExtractor::Sentence.new(sentence).activities
          end.flatten
      end

      def sentences_events_matches
        @sentences_activities_matches ||=
          text.sentences_objects.map do |sentence|
            ElementExtractor::Sentence.new(sentence).events
          end.flatten
      end
    
      def text
        @text ||= StanfordCore::Text.new(@string)
      end
    end    
  end
end
