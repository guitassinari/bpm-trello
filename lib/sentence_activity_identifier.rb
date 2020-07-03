# frozen_string_literal: true

class SentenceActivityIdentifier
  def initialize(sentence)
    @sentence = sentence
  end

  def activity

  end

  def has_activity?
    return false unless @sentence.has_verb?
  end

  # https://stanfordnlp.github.io/CoreNLP/tokensregex.html
  def teste
    # https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/ling/tokensregex/TokenSequencePattern.html
    StanfordCoreNLP.load_class('TokenSequencePattern', 'edu.stanford.nlp.ling.tokensregex')
    env = StanfordCoreNLP::TokenSequencePattern.new_env
    # // set to case insensitive
    StanfordCoreNLP.load_class('NodePattern', 'edu.stanford.nlp.ling.tokensregex')
    StanfordCoreNLP.load_class('Pattern', 'java.util.regex')
    env.set_default_string_match_flags(StanfordCoreNLP::NodePattern.CASE_INSENSITIVE | StanfordCoreNLP::Pattern.UNICODE_CASE)
    # env.set_default_string_pattern_flags(StanfordCoreNLP::Pattern.CASE_INSENSITIVE | StanfordCoreNLP::Pattern.UNICODE_CASE)

    StanfordCoreNLP.load_class('CoreMapExpressionExtractor', 'edu.stanford.nlp.ling.tokensregex')
    extractor = StanfordCoreNLP::CoreMapExpressionExtractor.create_extractor_from_string(env, '{ pattern: ( "Alessandro" ), result: "ALESSANDRO" }')

    puts(@sentence.to_s)
    expressions = extractor.extract_expressions(@sentence.nlp_proxy)

    expressions.each do |e|
      expression = Expression.new(e)
    end
  end
end

class Expression < NlpWrapper
  def id
    value.to_s
  end

  private

  def value
    send_nlp(:value)
  end
end
