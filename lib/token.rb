class Token < NlpWrapper

  def determiner?
    part_of_speech_tag == 'DT'
  end

  def part_of_speech_tag
    get_annotation(:part_of_speech).to_s
  end

  def lemma
    get_annotation(:lemma).to_s
  end

  def coreference_cluster_id
    id = get_annotation(:coref_cluster_id)
    return nil if id.to_s.empty?

    id.to_s.to_i
  end

  def to_s
    send_nlp(:value).to_s
  end
end
