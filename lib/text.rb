class Pipeline
  def initialize
    @@pipeline ||= StanfordCoreNLP.load(:tokenize, :ssplit, :parse, :pos, :lemma)
    @features = []
  end

  def annotate_text(text_as_string)
    text = StanfordCoreNLP::Annotation.new(text_as_string)
    pipeline.annotate(text)
    text
  end

  private

  def pipeline
    @@pipeline
  end
end

class Text
  COORDINATING_CONJUNCTION = "CC"
  CARDINAL_NUMBER = "CD"
  DETERMINER = "DT"
  EXISTENCIAL_THERE = "EX"
  PREPOSITION = "IN"
  ADJECTIVE = "JJ"
  ADJECTIVE_COMPARATIVE = "JJR"
  ADJECTIVE_SUPERLATIVE = "JJS"
  MODAL = "MD"
  NOUN = "NN"
  PROPER_NOUN = "NNP"
  NOUN_PLURAL = "NNS"
  PERSONAL_PRONOUN = "PRP"
  POSSESSIVE_PRONOUN = "PRP$"
  ADVERB = "RB"
  ADVERB_COMPARATIVE = "RBR"
  ADVERB_SUPERLATIVE = "RVS"
  VERB = "VB"
  VERB_PAST_TENSE = "VBD"
  VERB_PAST_PARTICIPLES = "VBN"
  VERB_GERUND = "VBG"

  def initialize(string = "")
    @string = string
  end

  def sentences
    sents = []
    wrapped_sentences.each do |sentence|
      sents.push(sentence.original_text)
    end
    sents
  end

  def sentences_parts_of_speech
    parts_of_speech = []
    core_sentences.each do |sentence|
      puts(sentence.get(:text).to_s)
      sentence_pos = [] 
      sentence.get(:tokens).each do |token|
        sentence_pos.push(token.get(:part_of_speech).to_s)
      end
      parts_of_speech.push(sentence_pos)
    end
    parts_of_speech
  end

  def lemmas
    lms = []
    each_token do |token|
      lms.push(token.get(:lemma).to_s)
    end
    lms.join(' ')
  end

  def each_token
    wrapped_sentences.each do |sent|
      sent.each_token do |token|
        yield(token)
      end
    end
  end

  def activities
    acts = []
    wrapped_sentences.each do |sent|
      acts.push(sent.verb_phrases)
    end

    acts
  end

  private

  def wrapped_sentences
    @wrapped_sentences ||= begin
      acc = []
      core_sentences.each do |sent|
        acc.push(Sentence.new(sent))
      end
      acc
    end
  end

  def core_sentences
    annotated_text.get(:sentences)
  end

  def annotated_text
    @annotated_text ||= begin
      Pipeline.new.annotate_text(@string)
    end
  end
end

class Sentence
  VERB_PHRASE = 'VP'.freeze
  def initialize(core_nlp_sentence)
    @core_sentence = core_nlp_sentence
  end

  def each_token
    tokens.each { |token| yield(token) }
  end

  def tokens
    @core_sentence.get(:tokens)
  end

  def original_text
    @core_sentence.get(:text).to_s
  end

  def dependencies
    @core_sentence.get(:basic_dependencies).to_s
  end

  def verb_phrases
    @verb_phrases ||= begin
      phrases = []
      tree.each_subtree do |subtree|
        next unless subtree.verb_phrase?

        phrases.push(subtree.lemma_string)
      end
      phrases
    end
  end

  def tree
    @tree ||= Tree.new(@core_sentence.get(:tree))
  end
end

class Tree
  VERB_PHRASE = 'VP'.freeze
  def initialize(tree)
    @tree = tree
  end

  def verb_phrase?
    @tree.label.value == VERB_PHRASE
  end

  def each_subtree
    @tree.each { |t| yield(Tree.new(t)) }
  end

  def to_s
    @to_s ||= begin
      list = []
      each_leave do |leaf|
        list.push(leaf.to_s)
      end
      list.join(' ')
    end
  end

  def lemma_string
    Text.new(to_s).lemmas
  end

  private

  def each_leave
    leaves.each { |l| yield(l) }
  end

  def leaves
    @tree.get_leaves
  end
end
