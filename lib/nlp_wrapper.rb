class NlpWrapper
  def initialize(nlp_proxy)
    @nlp_proxy = nlp_proxy
  end

  def send_nlp(method, *arguments, &block)
    @nlp_proxy.send(:method_missing, method, *arguments, &block)
  end

  def get_annotation(annotation)
    @nlp_proxy.get(annotation)
  end

  def to_s
    send_nlp(:to_s)
  end
end