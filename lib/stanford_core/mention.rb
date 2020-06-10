# frozen_string_literal: true


module StanfordCore
  # A wrapper for Stanford CoreNlp mention class
  # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/Mention.html
  class Mention < NlpWrapper
    PROPER = 'PROPER'
    NOMINAL = 'NOMINAL'

    # Returns true if mention is of type PROPER
    def proper?
      type == PROPER
    end

    # Returns true if mention is of type NOMINAL
    def nominal?
      type == NOMINAL
    end

    # Returns the type of the mention, as defined by https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/Dictionaries.MentionType.html\
    # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/Dictionaries.MentionType.html
    def type
      send_nlp(:mention_type).to_s
    end

    # Returns the mention's original text
    def to_s
      send_nlp(:mention_span)
    end
  end
end
