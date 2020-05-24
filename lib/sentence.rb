class Sentence
  def initialize(core_nlp_sentence)
    @core_sentence = core_nlp_sentence
  end

  def original_text
    @core_sentence.get(:text).to_s
  end

  def dependencies
    @core_sentence.get(:basic_dependencies).to_s
  end

  def parts_of_speech
    tokens.map(&:part_of_speech_tag)
  end

  def activities_phrases
    @activities_phrases ||= TreeActivitiesIdentifier.new(tree).activities_phrases
  end

  def tokens
    @tokens ||= begin
      token_list = []
      each_token { |token| token_list.push(token) }
      token_list
    end
  end
  
  private

  def tree
    @tree ||= Tree.new(nlp_tree)
  end

  def each_token
    nlp_tokens.each { |token| Token.new(yield(token)) }
  end

  def nlp_tokens
    @core_sentence.get(:tokens)
  end

  def nlp_tree
    @core_sentence.get(:tree)
  end
end

class Token
  def initialize(nlp_token)
    @nlp_token = nlp_token
  end

  def part_of_speech_tag
    @nlp_token.get(:part_of_speech).to_s
  end

  def lemma
    @nlp_token.get(:lemma).to_s
  end
end