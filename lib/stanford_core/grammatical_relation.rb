# frozen_string_literal: true

module StanfordCore
  # https://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/GrammaticalRelation.html
  class GrammaticalRelation < NlpWrapper
    StanfordCoreNLP.load_class('GrammaticalRelation', 'edu.stanford.nlp.trees')
    NSUBJ = new(StanfordCoreNLP::GrammaticalRelation.value_of("nsubj"))
  end
end
  