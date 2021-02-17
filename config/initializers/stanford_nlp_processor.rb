# frozen_string_literal: true

StanfordCoreNLP.use :english
StanfordCoreNLP.model_files = {}
StanfordCoreNLP.default_jars = [
  'joda-time.jar',
  'xom.jar',
  'stanford-corenlp-3.5.0.jar',
  'stanford-corenlp-3.5.0-models.jar',
  'jollyday.jar',
  'bridge.jar'
]
