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

  def coreference?
    coreference_cluster_id.present?
  end

  def coreference_cluster_id
    return nil if coref_cluster_id_string.empty?

    coref_cluster_id_string.to_i
  end

  def to_s
    send_nlp(:value).to_s
  end

  private

  def coref_cluster_id_string
    coref_cluster_id_annotation.to_s
  end

  def coref_cluster_id_annotation
    get_annotation(:coref_cluster_id)
  end  
end
