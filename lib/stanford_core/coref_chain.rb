# frozen_string_literal: true

module StanfordCore
  # Wrapper for the CorefChain Stanford CoreNLP Java class binding
  # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/CorefChain.html
  class CorefChain < NlpWrapper
    # gets a coref mention set by it's ID
    # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/CorefChain.html#getMentionMap--
    # @return [StanfordCore::CorefMentionSet] coref mention set of given id
    def coref_set_by_id(id)
      nlp_coref_set = send_nlp(:get, id)
      CorefMentionSet.new(nlp_coref_set)
    end

    # The size of the coref chain
    # @return [Number] coref chain size
    def length
      send_nlp(:size)
    end
  end
end
