module Bpm
  module ElementExtractor
    module Regex
      module Activity
        include Base

        # Regular expressions for activity identification in natural language texts
        # according to Ferreira's rules.
        REGEXES = [
          RegexRule.new(/(#{SUBJECT}#{CONNECTORS}#{VERB_AND_OBJECT})/, "ACT_1"),
          RegexRule.new(/(#{SUBJECT}#{CONNECTORS}#{MODIFIED_VERB}#{CONNECTORS}#{OBJECT})/, "ACT_2"),
          RegexRule.new(/(#{VERB_AND_OBJECT})/, "ACT_3"),
          RegexRule.new(/(#{SUBJECT}#{CONNECTORS}#{VERB_AND_OBJECT}#{CONNECTORS}#{VERB_AND_OBJECT})/, "ACT_4"),
          RegexRule.new(/(#{OBJECT}#{CONNECTORS}#{SUBJECT}#{CONNECTORS}#{VERB_PARTICIPLE})/, "ACT_5"),
          RegexRule.new(/(#{VERB_AND_OBJECT}#{CONJUNCTION}#{VERB_AND_OBJECT})/, "ACT_6")
        ]
      end
    end
  end
end
