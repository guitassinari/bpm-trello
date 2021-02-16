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

  # https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/semgraph/SemanticGraph.html
  class SemanticGraph < NlpWrapper
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

    def noun_modifiers_of(noun_indexed_word)
      get_children_by_relation(noun_indexed_word, GrammaticalRelation.noun_compound_modifier)
    end

    def subject_relations
      find_edges_by_relation(GrammaticalRelation.nsubj)
    end

    def all_objects_of(indexed_word)
      objects = get_children_by_relation(indexed_word, GrammaticalRelation.object)
      d_objects = get_children_by_relation(indexed_word, GrammaticalRelation.direct_object)
      ind_objects = get_children_by_relation(indexed_word, GrammaticalRelation.indirect_object)
      objects + d_objects + ind_objects
    end

    def all_subjects_of(indexed_word)
      get_children_by_relation(indexed_word, GrammaticalRelation.nsubj)
    end

    def all_conjunctions_of(indexed_word)
      get_children_by_relation(indexed_word, GrammaticalRelation.conj)
    end

    def get_children_by_relation(indexed_word, relation)
      iterable_method_to_array(:get_children_with_reln, IndexedWord, indexed_word.nlp_proxy, relation)
    end

    private

    def find_edges_by_relation(relation)
      # relation must be a Java bridge object got by GrammaticalRelation.get_english_relation_by_name
      iterable_method_to_array(:find_all_relns, SemanticGraphEdge, relation)
    end


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
    class << self
      def conj
        get_english_relation_by_name("CONJUNCT")
      end

      def nsubj
        get_english_relation_by_name("NOMINAL_SUBJECT")
      end

      def object
        get_english_relation_by_name("OBJECT")
      end

      def direct_object
        get_english_relation_by_name("DIRECT_OBJECT")
      end

      def indirect_object
        get_english_relation_by_name("INDIRECT_OBJECT")
      end

      def noun_compound_modifier
        get_english_relation_by_name("NOUN_COMPOUND_MODIFIER")
      end

      def get_english_relation_by_name(name)
        english_relations.send(name)
      end

      private

      # https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/trees/EnglishGrammaticalRelations.html
      def english_relations
        @english_relations ||= StanfordCoreNLP.load_class('EnglishGrammaticalRelations', 'edu.stanford.nlp.trees')
      end
    end
  end

  # https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/semgraph/SemanticGraphEdge.html
  class SemanticGraphEdge < NlpWrapper

    def governor
      IndexedWord.new(gov)
    end

    def dependent
      IndexedWord.new(dep)
    end

    private


    def dep
      send_nlp(:get_dependent)
    end

    def gov
      send_nlp(:get_governor)
    end
  end

  # https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/ling/IndexedWord.html
  class IndexedWord < NlpWrapper
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
