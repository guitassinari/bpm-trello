# frozen_string_literal: true

class CorefChainMap < NlpWrapper
  def coref_chain_by_id(id)
    nlp_coref = send_nlp(:get, id)
    CorefChain.new(nlp_coref)
  end

  def length
    send_nlp(:size)
  end
end

