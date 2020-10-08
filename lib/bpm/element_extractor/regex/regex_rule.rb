module Bpm
  module ElementExtractor
    module Regex
      # This class encapsulates Regular Expressions for BPM elements identification.
      # One of it's responsibilities is to hold the regex ID in a way the program
      # can find which Rule was matched by a found BPM Element.
      class RegexRule
        def initialize(regex, rule_id)
          @regex = regex
          @rule_id = rule_id
        end

        def matches_for(sentence)
          Bpm::ElementExtractor::Utilities::SentencePosRegexApplier
            .new(sentence, self)
            .matches
        end

        attr_reader :regex, :rule_id

        def id
          @rule_id
        end

        def to_s
          @regex
        end
      end
    end
  end
end