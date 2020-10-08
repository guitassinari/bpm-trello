module BpmTrello
  module ElementExtractor
    def extract_activities
      Bpm::ElementExtractor::Text.new(preprocessed_text).activities
    end

    def extract_events
      Bpm::ElementExtractor::Text.new(preprocessed_text).events
    end

    def preprocessed_text
      @preprocessed_text ||=
        BpmTrello::TextPreprocessorFacade.new(comments_as_conversation).preprocess
    end
  end
end