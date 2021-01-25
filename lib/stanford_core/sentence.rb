# frozen_string_literal: true

module StanfordCore
  # A wrapper for Stanford CoreNlp sentence class
  class Sentence < NlpWrapper
    VERBS = ["VB", "VBD", "VBG", "VBN", "VBP", "VBZ"]
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
      semantic_graph.to_s
    end

    # list of the sentence's tokens part of speech tags
    # @example
    #  ['NNP', ',', 'VB', 'NN', 'DT', 'JJ', 'IN', 'IN', 'PRP', 'MD', 'VB', 'PRP',
    #   'TO', 'NNP', '.']
    # @return [Array<String>] list of part of speech tags
    def parts_of_speech
      tokens.map(&:part_of_speech_tag)
    end

    def parser_parts_of_speech
      semantic_graph.pos_tags
    end

    def lemmatize
      semantic_graph.topological_sorted_indexed_words.map do |indexed_word|
        if indexed_word.pos_tag =~ /(VB)(D|G|N|P|Z)?/
          indexed_word.lemma
        else
          indexed_word.word
        end
      end.join(' ')
    end

    # list of tokens in the sentence
    # @return [Array<StanfordCore::Token>] list of tokens
    def tokens
      @tokens ||= begin
        token_list = []
        nlp_tokens.each { |token| token_list.push(Token.new(token)) }
        token_list
      end
    end

    # the sentence tree
    # @return [StanfordCore::Tree] the sentence tree
    def tree
      @tree ||= Tree.new(nlp_tree)
    end

    # wether the sentence has a verb
    def has_verb?
      !(parser_parts_of_speech & VERBS).empty?
    end

    def question?
      tokens.last.to_s == '?'
    end

    def semantic_graph
      @semantic_graph ||= SemanticGraph.new(nlp_semantic_graph)
    end

    private

    def nlp_semantic_graph
      get_annotation(:basic_dependencies)
    end

    def nlp_tokens
      get_annotation(:tokens)
    end

    def nlp_tree
      get_annotation(:tree)
    end
  end

  # https://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/semgraph/SemanticGraph.html
  class SemanticGraph < NlpWrapper
    # TODO: Ver metodos getEdge
    def root
      IndexedWord.new(first_root)
    end

    def roots
      @roots ||= iterable_method_to_array(:get_roots, IndexedWord)
    end

    def pos_tags
      @pos_tags ||= topological_sorted_indexed_words.map(&:pos_tag)
    end

    def values
      @parser_tags ||= topological_sorted_indexed_words.map(&:value)
    end

    def words
      topological_sorted_indexed_words.map(&:word)
    end

    def relations
      typed_dependencies.map(&:relation)
    end

    def topological_sorted_indexed_words
      @topological_sorted_indexed_words ||=
        iterable_method_to_array(:vertex_list_sorted, IndexedWord)
    end

    def typed_dependencies
      @typed_dependencies ||= 
        iterable_method_to_array(:typed_dependencies, TypedDependency)
    end

    private

    def first_root
      send_nlp(:get_first_root)
    end
  end

  # https://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/TypedDependency.html
  class TypedDependency < NlpWrapper
    def relation
      # https://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/GrammaticalRelation.html
      grammatical_relation.to_s
    end

    def grammatical_relation
      GrammaticalRelation.new(reln)
    end

    def governor
      IndexedWord.new(gov)
    end

    def dependent
      IndexedWord.new(dep)
    end

    private

    def reln
      send_nlp(:reln)
    end

    def dep
      send_nlp(:dep)
    end

    def gov
      send_nlp(:gov)
    end
  end

  # https://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/GrammaticalRelation.html
  class GrammaticalRelation < NlpWrapper
  end

  # https://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/ling/IndexedWord.html
  class IndexedWord < NlpWrapper
    def lemmatize_if_can
      return lemma || word
    end

    def pos_tag
      send_nlp(:tag)
    end

    def value
      send_nlp(:value)
    end

    def word
      send_nlp(:word)
    end

    def lemma
      send_nlp(:lemma) || word
    end
  end
end
