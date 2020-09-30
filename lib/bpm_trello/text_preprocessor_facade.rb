module BpmTrello
  class TextPreprocessorFacade
    def initialize(text)
      @text = text
    end

    def preprocess
      Preprocess::Text.new(@text)
                      .add_period_if_needed
                      .remove_new_lines
                      .substitute_markdown_links
                      .remove_parenthesis
                      .substitute_coreferences
                      .to_s
    end
  end
end