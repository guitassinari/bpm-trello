# frozen_string_literal: true

require 'singleton'

module StanfordCore
  # Singleton class used to instantiate the Stanford Core NLP pipeline
  # @author Guilherme Tassinari
  class NlpPipeline
    def initialize
      @pipeline = StanfordCoreNLP.load(:tokenize,
                                       :ssplit,
                                       :parse,
                                       :pos,
                                       :lemma,
                                       :ner,
                                       :dcoref)
      @features = []
    end

    # Annotates the received string and returns an instance of StanfordCoreNlp::Annotation
    # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/pipeline/Annotation.html
    # @param [String] string the string to be annotated
    # @return [StanfordCoreNLP::Annotation] annotated text (as Annotation)
    def annotate_text(string)
      text = StanfordCoreNLP::Annotation.new(string)
      pipeline.annotate(text)
      text
    end

    private

    def pipeline
      @pipeline
    end
  end
end
