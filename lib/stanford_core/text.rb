# frozen_string_literal: true

module StanfordCore
  # @author Guilherme Tassinari
  # Main class for annotating text using the Stanford NLP parser.
  class Text < NlpWrapper
    # @param [String] string string containing the text to be analyzed / parsed by the stanford NLP parser
    def initialize(string)
      @string = string || ''
    end

    # Returns a CorefChainMap instance wrapping the Stanford NLP CoreChain for
    # the current text
    # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/CorefChain.html
    # @see StanfordCore::CorefChainMap
    # @return [StanfordCore::CorefChainMap] a Coreference Chain Map wrapper
    def coreference_chain
      CorefChain.new(nlp_coref_chain)
    end

    # Gets all part-of-speech tags of the current text, in the order they appear
    # @return [Array<String>] list of all pos tags of the text
    def parts_of_speech
      tokens.map(&:part_of_speech_tag)
    end

    # Gets all part-of-speech tags of the current text, in the order they appear
    # @return [Array<String>] list of all pos tags of the text
    def parser_parts_of_speech
      sentences_objects.map(&:parser_tags).flatten
    end

    # Gets all lemmas of the current text, in the order they appear
    # @return [Array<String>] list of all lemmas of the text
    def lemmas
      tokens.map(&:lemma)
    end

    # List of tokens in the text in the form of Stanford NLP token wrappers
    # @see StanfordCore::Token
    # @return [Array<StanfordCore::Token>] list of all tokens of the text
    def tokens
      sentences_objects.map(&:tokens).flatten
    end

    # list of text's sentences as strings
    # @return [Array<String>] sentences strings
    def sentences
      sentences_objects.map(&:original_text)
    end

    # all sentences of the text, in the order they're found
    # @see StanfordCore::Sentence
    # @return [Array<StanfordCore::Sentence>] list of sentences
    def sentences_objects
      @sentences_objects ||= begin
        acc = []
        each_nlp_sentence do |sent|
          acc.push(Sentence.new(sent))
        end
        acc
      end
    end

    private

    def nlp_coref_chain
      annotated_text.get(:coref_chain)
    end

    def each_nlp_sentence
      core_sentences.each { |s| yield(s) }
    end

    def core_sentences
      annotated_text.get(:sentences)
    end

    def nlp_proxy
      annotated_text
    end

    def annotated_text
      @annotated_text ||= begin
        NlpPipeline.new.annotate_text(@string)
      end
    end
  end
end
