module Bpm
  module ElementExtractor
    module Utilities
      class Match
        def initialize(string, rule)
          @string = string
          @rule = rule
        end

        attr_reader :string, :rule

        def to_s
          string
        end

        def length
          string.length
        end
      end
    end
  end
end

