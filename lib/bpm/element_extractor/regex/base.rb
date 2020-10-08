module Bpm
  module ElementExtractor
    module Regex
      # Base regular expressions upon which BPM identification regular expressions
      # are built.
      module Base
        VERB = /(VB)(D|G|N|P|Z)?/
        VERB_PRESENT = /(VB)/
        VERB_NOT_PAST = /(VB)(G|Z)?/
        VERB_PARTICIPLE = /(VB)(G|N)/
        VERB_PAST = /(VBP)/
        VERB_PAST_PARTICIPLE = /(VBN)/
        MODIFIED_VERB = /(MD) #{VERB}/
        OBJECT = /((NN)(PS|P|S)?)/
        SUBJECT = /((NN)(PS|P|S)?)/
        CONNECTORS = /((\s?[!-z]*\s?){0,3}?)/
        VERB_AND_OBJECT = /(#{VERB_NOT_PAST}#{CONNECTORS}#{OBJECT})/
        CONJUNCTION = /CC/
      end
    end
  end
end