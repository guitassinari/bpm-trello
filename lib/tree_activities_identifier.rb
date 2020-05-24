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
    @activities_phrases_candidates ||= verb_phrases_subtrees.map(&:verb_phrase_and_noun_phrase)
  end

  def verb_phrases_subtrees
    @tree.subtrees.select(&:verb_phrase_with_noun?)
  end
end