# frozen_string_literal: true

# https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/Dictionaries.MentionType.html
module StanfordCore
  class Mention < NlpWrapper
    PROPER = 'PROPER'
    NOMINAL = 'NOMINAL'

    def proper?
      type == PROPER
    end

    def nominal?
      type == NOMINAL
    end

    def type
      send_nlp(:mention_type).to_s
    end

    def to_s
      send_nlp(:mention_span)
    end
  end
end