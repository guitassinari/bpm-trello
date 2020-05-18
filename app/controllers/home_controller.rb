# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
   'Berlin to discuss a new austerity package. Sarkozy ' +
   'looked pleased, but Merkel was dismayed.'

    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
    text = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(text)
    @sentences = text.get(:sentences)
  end
end
