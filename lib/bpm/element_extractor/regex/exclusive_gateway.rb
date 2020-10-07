module Bpm
  module ElementExtractor
    module Regex
      module ExclusiveGateway
        include Base

        SIGNAL_WORD = CONNECTORS
        ALTERNATIVE_SIGNAL_WORD = CONNECTORS
        TASK_OR_EVENT = /(#{Event::EVENT}|#{Activity::ACTIVITY})/
        CONDITION = TASK_OR_EVENT

        # Regular expressions for event identification in natural language texts
        # according to Ferreira's rules.
        REGEXES = [
          RegexRule.new(/(#{VERB}#{CONNECTORS}#{SIGNAL_WORD}#{SUBJECT}#{CONNECTORS}#{OBJECT})/, "XOR_1"),
          RegexRule.new(/(#{SIGNAL_WORD}#{CONNECTORS}#{CONDITION}#{CONNECTORS}#{TASK_OR_EVENT}#{CONNECTORS}#{ALTERNATIVE_SIGNAL_WORD}#{CONNECTORS}#{Activity::ACTIVITY})/, "XOR_2"),
          RegexRule.new(/(#{TASK_OR_EVENT}#{CONNECTORS}#{SIGNAL_WORD}#{CONNECTORS}#{CONDITION})/, "XOR_3"),
          RegexRule.new(/(#{Activity::ACTIVITY}#{CONNECTORS}#{SIGNAL_WORD}#{CONNECTORS}#{CONDITION}#{CONNECTORS}#{ALTERNATIVE_SIGNAL_WORD}#{CONNECTORS}#{Activity::ACTIVITY})/, "XOR_4")
        ]

        EXCLUSIVE_GATEWAY = Regexp.new(REGEXES.join("|"))
      end
    end
  end
end
