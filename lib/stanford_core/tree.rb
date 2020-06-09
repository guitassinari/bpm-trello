# frozen_string_literal: true

module StanfordCore
  class Tree
    VERB_PHRASE = 'VP'
    NOUN_PHRASE = 'NP'
    VERB = 'VB'
    VERB_PAST_TENSE = 'VBD'
    VERB_PAST_PARTICIPLES = 'VBN'
    VERB_GERUND = 'VBG'
    PROPER_NOUN = 'NNP'
    PREPOSITION_PHRASE = 'PP'

    def initialize(tree)
      @tree = tree
    end

    def verb_phrase_with_noun?
      verb_phrase? && second_child_is_noun_phrase?
    end

    def verb_phrase?
      label_value == VERB_PHRASE
    end

    def preposition_phrase?
      label_value == PREPOSITION_PHRASE
    end

    def leaf?
      @tree.is_leaf
    end

    def verb?
      [VERB, VERB_PAST_TENSE, VERB_PAST_PARTICIPLES, VERB_GERUND]
        .include?(label_value)
    end

    def proper_noun?
      label_value == PROPER_NOUN
    end

    def noun_phrase?
      label_value == NOUN_PHRASE
    end

    # Includes self in the iteration
    def each_subtree
      @tree.each { |t| yield(Tree.new(t)) }
    end

    def each_child
      @tree.children.each do |child|
        yield(Tree.new(child))
      end
    end

    def to_s
      return @tree.to_s if leaf?

      @to_s ||= begin
        list = []
        each_leave do |leaf|
          list.push(leaf.to_s)
        end
        list.join(' ')
      end
    end

    def second_child_is_noun_phrase?
      second_child = @tree.children[1]
      return false if second_child.nil?

      Tree.new(second_child).noun_phrase?
    end

    def verb_phrase_and_noun_phrase
      return '' unless verb_phrase?

      verb = nil
      noun_phrase = nil

      each_subtree do |subtree|
        verb = subtree if subtree.verb?
        noun_phrase = subtree if subtree.noun_phrase?
        break if verb.present? && noun_phrase.present?
      end

      verb.lemma_string + ' ' + noun_phrase.generalized_string
    end

    def lemma_string
      Text.new(to_s).lemmas.join(' ')
    end

    def generalized_string
      list = []
      each_child do |subtree|
        if subtree.proper_noun?
          list.push('someone')
        elsif subtree.leaf?
          list.push(subtree.to_s)
        else
          list.push(subtree.generalized_string)
        end
      end
      list.chunk(&:itself).map(&:first).join(' ')
    end

    def dependencies
      @tree.to_s
    end

    def label_value
      @label_value ||= @tree.label.value
    end

    def subtrees
      @subtrees ||= begin
        list = []
        each_subtree do |subtree|
          list.push(subtree)
        end
        list
      end
    end

    private

    def each_leave
      leaves.each { |l| yield(Tree.new(l)) }
    end

    def leaves
      @tree.get_leaves
    end
  end
end
