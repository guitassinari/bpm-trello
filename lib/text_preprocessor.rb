# frozen_string_literal: true

class TextPreprocessor
  def initialize(text)
    @text = text
  end

  def substitute_coreferences
    acc = @text.tokens.map do |token|
      if token.coreference_cluster_id.present?
        coref = find_coref(token.coreference_cluster_id)
        mention = coref.representative_mention
        if mention.proper? 
          mention.to_s
        elsif mention.nominal? # removes this, these, those, that...
          mention.to_s.split.slice(-1, 1).join(' ')
        else
          token.to_s
        end
      elsif token.determiner?
        nil
      else
        token.to_s
      end
    end
  
    # removes nils and joins
    acc.compact.join(' ')
  end

  def find_coref(id)
    @text.coreference_chain.coref_chain_by_id(id)
  end
end