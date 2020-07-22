# frozen_string_literal: true

module StanfordCore
  # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/patterns/surface/Token.html
  class Token < NlpWrapper
    # Returns whether the token is a determiner
    # @see http://www.cse.unsw.edu.au/~billw/nlpdict.html#determiner
    # @example
    #   a, an, my, your, this, those, first, second, many, few
    def determiner?
      part_of_speech_tag == 'DT'
    end

    def verb?
      part_of_speech_tag =~ /VB/
    end

    def comma?
      part_of_speech_tag =~ /,/
    end

    # Returns the token's part of speech tag
    # @return [String] part of speech tag
    def part_of_speech_tag
      get_annotation(:part_of_speech).to_s
    end

    # Returns the token's lemma
    # @return [String] lemma
    def lemma
      get_annotation(:lemma).to_s
    end

    # Returns wether token's is a coreference (belongs to a Stanford CoreNLP).
    def coreference?
      coreference_cluster_id.present?
    end

    # Returns the token's coreference cluster ID.
    # The coreference cluster ID can be used as parameter for
    # {StanfordCore::CorefChain#coref_set_by_id} to get the correspondig
    # coreference set
    # @return [Number] coreference cluster id
    def coreference_cluster_id
      return nil if coref_cluster_id_string.blank?

      coref_cluster_id_string.to_i
    end

    # Returns the token's original string
    # @return [String] original token value
    def to_s
      send_nlp(:value).to_s
    end

    private

    def coref_cluster_id_string
      @coref_cluster_id_string ||=
        coref_cluster_id_annotation.to_s
    end

    def coref_cluster_id_annotation
      get_annotation(:coref_cluster_id)
    end
  end
end
