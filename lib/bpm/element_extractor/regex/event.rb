module Bpm
  module ElementExtractor
    module Regex
      module Event
        include Base

        # Regular expressions for event identification in natural language texts
        # according to Ferreira's rules.
        REGEXES = [
          RegexRule.new(/(#{SUBJECT}#{CONNECTORS}#{VERB_PAST_PARTICIPLE}#{CONNECTORS}#{OBJECT})/, "EVT_1_2"),
          RegexRule.new(/(#{OBJECT}#{CONNECTORS}#{VERB_PAST_PARTICIPLE})/, "EVT_3"),
          RegexRule.new(/(#{OBJECT}#{CONNECTORS}#{VERB_PAST}#{CONNECTORS}#{SUBJECT})/, "EVT_4")
        ]
      end
    end
  end
end