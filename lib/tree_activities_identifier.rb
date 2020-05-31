# frozen_string_literal: true

class TreeActivitiesIdentifier
  def initialize(tree)
    @tree = tree
  end

  def activities_phrases
    @activities_phrases ||= unique_activities_phrases
  end

  private

  def unique_activities_phrases
    activities_phrases_candidates.reverse.each do |phrase|
      activities_phrases_candidates.reverse.each do |other_phrase|
        next if other_phrase == phrase

        if other_phrase.include?(phrase)
          activities_phrases_candidates.delete(other_phrase)
        end
      end
    end
  end

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

    @tree.subtrees.each do |subtree|
      verb = subtree if subtree.verb?
      noun_phrase = subtree if subtree.noun_phrase?
      binding.pry if noun_phrase
      break if verb.present? && noun_phrase.present?
    end

    verb.lemma_string + ' ' + noun_phrase.generalized_string
  end
end