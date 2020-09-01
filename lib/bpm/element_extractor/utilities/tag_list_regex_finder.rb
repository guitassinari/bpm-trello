module Bpm
  module ElementExtractor
    module Utilities
      class TagListRegexFinder
        def initialize(tag_list, regex)
          @tag_list = tag_list
          @regex = regex
        end

        def matches_ranges
          token_ranges_for_matches
        end

        private
        
        attr_reader :tag_list, :regex

        def tag_string
          tag_list.join(' ')
        end

        def token_ranges_for_matches
          scan_for_matches.map do |pos_sub_string|
            position_range_of_substring(pos_sub_string)
          end
        end
      
        def scan_for_matches
          tag_string.scan(regex).map(&:first)
        end
      
        def position_range_of_substring(sub_string)
          begins_at = tag_string.index(sub_string)
          begins_at_token = tag_string.slice(0, begins_at).count(' ')
          number_of_tokens = sub_string.split(' ').size
          ends_at_token = begins_at_token+number_of_tokens
          [begins_at_token, ends_at_token]
        end
      end
    end
  end
end
