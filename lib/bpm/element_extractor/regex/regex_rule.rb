module Bpm
  module ElementExtractor
    module Regex
      class RegexRule
        def initialize(regex, rule_id)
          @regex = regex
          @rule_id = rule_id
        end

        attr_reader :regex, :rule_id

        def id
          @rule_id
        end
      end
    end
  end
end