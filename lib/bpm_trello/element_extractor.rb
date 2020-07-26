module BpmTrello
  module ElementExtractor
    def extract_activities(text)
      Bpm::ElementExtractor::Text.new(text).activities
    end
  end
end