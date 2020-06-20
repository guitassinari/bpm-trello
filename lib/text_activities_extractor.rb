# frozen_string_literal: true

class TextActivitiesExtractor
  def initialize(string)
    @string = string
  end

  def activities
    unique_activities_phrases
  end

  private

  def unique_activities_phrases
    reversed_sentences = sentences_activities.reverse
    reversed_sentences.each do |phrase|
      reversed_sentences.each do |other_phrase|
        next unless other_phrase != phrase

        reversed_sentences.delete(phrase) if other_phrase.include?(phrase)
      end
    end

    reversed_sentences.uniq
  end

  def sentences_activities
    @sentences_activities ||=
      text.sentences_objects.map do |sentence|
        sentence_activities(sentence)
      end.flatten
  end

  def sentence_activities(sentence)
    TreeActivitiesExtractor.new(sentence.tree).activities_phrases
  end

  def text
    @text ||= StanfordCore::Text.new(@string)
  end
end
