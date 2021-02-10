# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Actuators
      class Base
        def initialize(card)
          @card = card
        end

        private

        attr_reader :card
      end  
    end
  end
end
