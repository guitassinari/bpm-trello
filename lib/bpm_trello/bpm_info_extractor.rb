# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    def self.extract_from(card)
      card.name + card.desc
    end
  end  
end
