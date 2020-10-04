module Bpm
  module ElementExtractor
    module Regex
      module ExclusiveGateway
        include Base

        # Regular expressions for event identification in natural language texts
        # according to Ferreira's rules.
        REGEXES = [
          RegexRule.new(/(#{VERB}#{CONNECTORS}#{VERB_PAST_PARTICIPLE}#{CONNECTORS}#{OBJECT})/, "XOR_1"),
        ]
      end
    end
  end
end
