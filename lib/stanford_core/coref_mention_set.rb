# frozen_string_literal: true

module StanfordCore
  # Wrapper for a Set of CorefMentions
  # @see https://nlp.stanford.edu/nlp/javadoc/javanlp-3.5.0/edu/stanford/nlp/dcoref/CorefChain.html#getMentionMap--
  class CorefMentionSet < NlpWrapper
    # The most representative mention according to Stanford CoreNLP Parser
    # @return [StanfordCore::Mention] most representative mention
    def representative_mention
      Mention.new(send_nlp(:get_representative_mention))
    end

    # list of all mentions in the order they appear
    # @return [Array<StanfordCore::Mention>] list of mentions
    def mention_list
      @mention_list ||= begin
        mentions = []
        send_nlp(:get_mentions_in_textual_order).each do |mention|
          mentions.push(Mention.new(mention))
        end
        mentions
      end
    end
  end
end
