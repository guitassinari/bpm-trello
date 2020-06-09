# frozen_string_literal: true

module StanfordCore
  class CorefChain < NlpWrapper
    def mention_map
      send_nlp(:get_mention_map)
    end

    def representative_mention
      Mention.new(send_nlp(:get_representative_mention))
    end

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
