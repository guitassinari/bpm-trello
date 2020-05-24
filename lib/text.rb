class Text
  def initialize(string)
    @string = string || ''
  end

  def sentences_original_texts
    sentences.map(&:original_text)
  end

  def sentences_parts_of_speech
    sentences.map(&:parts_of_speech)
  end

  def lemmas
    tokens.map(&:lemma).join(' ')
  end

  def tokens
    sentences.map(&:tokens).flatten
  end

  def activities
    sentences.map(&:activities_phrases).flatten
  end

  private
  
  def sentences
    @sentences ||= begin
      acc = []
      each_nlp_sentence do |sent|
        acc.push(Sentence.new(sent))
      end
      acc
    end
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

