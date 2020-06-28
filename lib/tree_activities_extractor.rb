# frozen_string_literal: true

class TreeActivitiesExtractor
  def initialize(tree)
    @tree = tree
  end

  def activities_phrases
    @activities_phrases ||= activities_phrases_candidates.uniq
  end

  private

  def activities_phrases_candidates
    @activities_phrases_candidates ||=
      verb_phrases_subtrees.map do |tree|
        ActivityPhraseBuilder.new(tree).to_s
      end
  end

  def verb_phrases_subtrees
    @tree.subtrees.select(&:verb_phrase_with_noun?)
  end
end

class ActivityPhraseBuilder
  def initialize(tree)
    @tree = tree
  end

  def to_s
    verb_phrase_and_noun_phrase
  end

  def verb_phrase_and_noun_phrase
    return '' unless @tree.verb_phrase?

    verb = nil
    noun_phrase = nil
    preposition = nil

    @tree.subtrees.each do |subtree|
      verb = subtree if subtree.verb?
      noun_phrase = subtree if subtree.noun_phrase?
      preposition = subtree if subtree.preposition_phrase?
      break if verb.present? && noun_phrase.present? && preposition.present?
    end

    return '' if verb.blank?
    return verb.lemma_string if noun_phrase.blank?
    if preposition.blank?
      return verb.lemma_string + ' ' + noun_phrase.generalized_string
    end

    phrase = verb.lemma_string + ' ' + noun_phrase.generalized_string
    phrase += ' ' + preposition.lemma_string
    phrase
  end
end
