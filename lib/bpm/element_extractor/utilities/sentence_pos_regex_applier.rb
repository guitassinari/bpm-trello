module Bpm
  module ElementExtractor
    module Utilities
      class SentencePosRegexApplier
        def initialize(sentence, rule)
          @sentence = sentence
          @rule = rule
        end
      
        def matches
          matches_by_parser_tags
        end
      
        def matches_by_regular_tags
          find_matches_by_tag_list(regular_tag_list)
        end
      
        def matches_by_parser_tags
          find_matches_by_tag_list(parser_tag_list)
        end
      
        private

        def regex
          @rule.regex
        end
      
        def regular_tag_list
          @sentence.parts_of_speech
        end
      
        def parser_tag_list
          semantic_graph.pos_tags
        end
      
        def semantic_graph
          @sentence.semantic_graph
        end
      
        def token_ranges_for_matches(pos_tags_list)
          Bpm::ElementExtractor::Utilities::TagListRegexFinder.new(
            pos_tags_list,
            regex
          ).matches_ranges
        end
      
        def find_matches_by_tag_list(pos_tags_list)
          token_ranges_for_matches(pos_tags_list).map do |range|
            begins_at, ends_at = range
            string = sentence_substring_by_token_positions(begins_at, ends_at)
            pos_tags = pos_tags_list[begins_at..ends_at]
            Match.new(string, @rule, pos_tags)
          end
        end
      
        def sentence_substring_by_token_positions(begins_at, ends_at)
          tokens_excepct_punctuation[begins_at..ends_at]
            .map(&:to_s).join(' ').squeeze(' ')
        end

        def tokens_excepct_punctuation
          @tokens_excepct_punctuation ||= @sentence.tokens.reject do |token|
            [".", ","].include?(token.part_of_speech_tag) 
          end
        end
      end
    end
  end
end

