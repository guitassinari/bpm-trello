# frozen_string_literal: true

class TextPreprocessor
  def initialize(string)
    @string = string
    @text = Text.new(string)
  end

  def remove_determiners
    processed_string = @text.tokens.map do |token|
      if token.determiner?
        nil
      else
        token.to_s
      end
    end.compact.join(' ')
    TextPreprocessor.new(processed_string)
  end

  def substitute_coreferences
    processed_string = @text.tokens.map do |token|
      if token.coreference?
        coref = find_coref(token.coreference_cluster_id)
        mention = coref.representative_mention
        mention.to_s
      else
        token.to_s
      end
    end.compact.join(' ')

    TextPreprocessor.new(processed_string)
  end

  def to_s
    @string
  end

  private

  def find_coref(id)
    @text.coreference_chain.coref_chain_by_id(id)
  end
end