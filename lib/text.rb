# frozen_string_literal: true

class Text
  def initialize(string)
    @string = string || ''
  end

  def to_s
    annotated_text.to_s
  end

  def coreference_chain
    CorefChainMap.new(nlp_coref_chain)
  end

  def parts_of_speech
    sentences_objects.map(&:parts_of_speech).flatten
  end

  def lemmas
    tokens.map(&:lemma)
  end

  def tokens
    sentences_objects.map(&:tokens).flatten
  end

  def activities
    acts = sentences_objects.map(&:activities_phrases).flatten
    unique_activities_phrases(acts)
  end

  def sentences
    sentences_objects.map(&:original_text)
  end

  def send_nlp(method, annotation = false)
    return annotated_text.get(method) if annotation

    annotated_text.send(method)
  end

  def preprocessed
    preprocessed_string = TextPreprocessor.new(to_s)
                                          .substitute_coreferences
                                          .remove_determiners
                                          .to_s
    Text.new(preprocessed_string)
  end

  private

  def unique_activities_phrases(activities_phrases)
    activities_phrases.reverse.each do |phrase|
      activities_phrases.reverse.each do |other_phrase|
        next unless other_phrase != phrase

        activities_phrases.delete(phrase) if other_phrase.include?(phrase)
      end
    end

    activities_phrases.uniq
  end

  def sentences_objects
    @sentences_objects ||= begin
      acc = []
      each_nlp_sentence do |sent|
        acc.push(Sentence.new(sent))
      end
      acc
    end
  end

  def nlp_coref_chain
    annotated_text.get(:coref_chain)
  end

  def each_nlp_sentence
    core_sentences.each { |s| yield(s) }
  end

  def core_sentences
    annotated_text.get(:sentences)
  end

  def annotated_text
    @annotated_text ||= begin
      NlpPipeline.new.annotate_text(@string)
    end
  end
end
