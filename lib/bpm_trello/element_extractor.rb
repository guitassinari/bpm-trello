module BpmTrello
  module ElementExtractor
    def extract_activities(text)
      preprocessed_text = BpmTrello::TextPreprocessorFacade.new(text).preprocess
      Bpm::ElementExtractor::Text.new(preprocessed_text).activities
    end
  end
end