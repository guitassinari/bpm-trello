# frozen_string_literal: true

module StanfordCore
  # A wrapper for Stanford CoreNlp sentence class
  class Sentence < NlpWrapper
    # The sentence original unparsed text
    # @return [String] original sentence as string
    def original_text
      get_annotation(:text).to_s
    end

    # An idented string representing each token and it's dependency label
    # @example
    #  -> please/VB (root)
    #    -> Alessandro/NNP (nsubj)
    #    -> review/VB (xcomp)
    #      -> pull-request/NN (dobj)
    #        -> this/DT (det)
    #      -> get/VB (advcl)
    #        -> so/RB (advmod)
    #        -> that/IN (mark)
    #        -> we/PRP (nsubj)
    #        -> can/MD (aux)
    #        -> it/PRP (dobj)
    #        -> to/TO (prep)
    #          -> QA/NNP (pobj)
    # @return [String] indented string representing the sentence's dependency tree
    def dependencies
      get_annotation(:basic_dependencies).to_s
    end

    # list of the sentence's tokens part of speech tags
    # @example
    #  ['NNP', ',', 'VB', 'NN', 'DT', 'JJ', 'IN', 'IN', 'PRP', 'MD', 'VB', 'PRP',
    #   'TO', 'NNP', '.']
    # @return [Array<String>] list of part of speech tags
    def parts_of_speech
      tokens.map(&:part_of_speech_tag)
    end

    # list of tokens in the sentence
    # @return [Array<StanfordCore::Token>] list of tokens
    def tokens
      @tokens ||= begin
        token_list = []
        each_token { |token| token_list.push(token) }
        token_list
      end
    end

    # the sentence tree
    # @return [StanfordCore::Tree] the sentence tree
    def tree
      @tree ||= Tree.new(nlp_tree)
    end

    private

    def each_token
      nlp_tokens.each { |token| yield(Token.new(token)) }
    end

    def nlp_tokens
      get_annotation(:tokens)
    end

    def nlp_tree
      get_annotation(:tree)
    end
  end
end
