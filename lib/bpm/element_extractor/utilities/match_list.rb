module Bpm
  module ElementExtractor
    module Utilities
      class MatchList
        def initialize(matches = [])
          @matches = matches
        end

        def without_duplicates
          @without_duplicates ||= begin
            result = []
            matches.each do |match|
              match_group = [match]
              matches.each do |other_match|
                next unless match != other_match
                
                if match.duplicate_of?(other_match)
                  match_group.push(other_match)
                end
              end
              
              main_match = match_group.uniq(&:string).sort_by(&:length).last
              result.push(main_match)
            end
        
            result.uniq.reject(&:blank?)
          end
        end

        private

        attr_reader :matches
      end
    end
  end
end

