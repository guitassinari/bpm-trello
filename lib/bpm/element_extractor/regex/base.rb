module Bpm
  module ElementExtractor
    module Regex
      module Base
        VERB = /(VB)(D|G|N|P|Z)?/
        VERB_PRESENT = /(VB)/
        VERB_NOT_PAST = /(VB)(D|G|N|Z)?/
        VERB_PAST = /(VB)(P)?/
        MODIFIED_VERB = /(MD) #{VERB}/
        OBJECT = /((NN)(PS|P|S)?)/
        SUBJECT = /((NN)(PS|P|S)?)/
        CONNECTORS = /((\s?[!-z]*\s?){0,3})/
        VERB_AND_OBJECT = /(#{VERB_NOT_PAST}#{CONNECTORS}#{OBJECT})/
        CONJUNCTION = /(and|or)/
      end
    end
  end
end