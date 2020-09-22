module Bpm
  module ElementExtractor
    module Utilities
      class Match
        def initialize(string, rule, pos_tags)
          @string = string
          @rule = rule
          @pos_tags = pos_tags
        end

        attr_reader :string, :rule, :pos_tags

        def to_s
          Preprocess::Text.new(string).remove_stopwords.to_s
        end

        def length
          string.length
        end
      end
    end
  end
end

