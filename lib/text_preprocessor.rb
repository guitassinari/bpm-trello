# frozen_string_literal: true

# @author Guilherme Tassinari
# A text preprocessor for structuring and preparing text for future analysis.
# It must be used in the form of chained method calling, always ending with .to_s
# @example
#  TextPreprocessor.new("a text")
#                  .remove_determiners
#                  .substitute_coreferences
#                  .to_s
class TextPreprocessor
  # @param [String] string The text to be preprocessed
  def initialize(string)
    @string = string
    @processed_string = string
  end

  # Remove all determiners from text
  # @see http://www.cse.unsw.edu.au/~billw/nlpdict.html#determiner
  # @return [TextPreprocessor] returns the object itself for chaining methods
  def remove_determiners
    update_processed_string_chain do |token|
      if token.determiner?
        nil
      else
        token.to_s
      end
    end
  end

  # Substitute all coreferences for its most demonstrative form
  # @example
  #   "Open a pull-request and review it" => "Open a pull-request and review pull-request"
  # @return [TextPreprocessor] returns the object itself for chaining methods
  def substitute_coreferences
    update_processed_string_chain do |token|
      if token.coreference?
        coref = find_coref(token.coreference_cluster_id)
        mention = coref.representative_mention
        mention.to_s
      else
        token.to_s
      end
    end
  end

  # Returns the text preprocessed by all method chained calls in the order they
  # were called
  # @return [String] The preprocessed string
  def to_s
    normalized_processed_string
  end

  private

  def normalized_processed_string
    @processed_string
      .gsub(' .', '.') # remove spaces before periods
      .gsub(' ,', ',') # remove spaces before commas
      .strip           # remove traling spaces (start and end of string)
  end

  # Used to allow method chaining (returns self in the end)
  def update_processed_string_chain
    @processed_string = reduce_tokens_into_string do |token|
      yield(token)
    end
    self
  end

  def reduce_tokens_into_string
    processed_text.tokens.map do |token|
      yield(token)
    end.compact.join(' ')
  end

  def processed_text
    Text.new(@processed_string)
  end

  def find_coref(id)
    processed_text.coreference_chain.coref_set_by_id(id)
  end
end
