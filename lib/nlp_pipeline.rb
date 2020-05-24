class NlpPipeline
  def initialize
    @@pipeline ||= StanfordCoreNLP.load(:tokenize, :ssplit, :parse, :pos, :lemma)
    @features = []
  end

  def annotate_text(text_as_string)
    text = StanfordCoreNLP::Annotation.new(text_as_string)
    pipeline.annotate(text)
    text
  end

  private

  def pipeline
    @@pipeline
  end
end