module Bpm
  module ElementExtractor
    module Regex
      module Activity
        include Base

        REGEXES = [
          /(#{SUBJECT}#{CONNECTORS}#{VERB_AND_OBJECT})/, # Rule 1
          /(#{SUBJECT}#{CONNECTORS}#{MODIFIED_VERB}#{CONNECTORS}#{OBJECT})/, # Rule 2
          /(#{VERB_AND_OBJECT})/, # Rule 3
          /(#{SUBJECT}#{CONNECTORS}#{VERB_AND_OBJECT}#{CONNECTORS}#{VERB_AND_OBJECT})/, # Rule 4
          /(#{OBJECT}#{CONNECTORS}#{SUBJECT}#{CONNECTORS}#{VERB_NOT_PAST})/, # Rule 5
          /(#{CONNECTORS}#{VERB_AND_OBJECT}#{CONNECTORS}#{VERB_AND_OBJECT})/ # Rule 6
        ]
      end
    end
  end
end
