# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class MentionSubstitution < Base
        def run
          resolved_comment_texts = card.comments.map { |c| substitute_anaphoras_in_comment(c) }
          resolved_description = substitute_anaphoras_in_description(card.desc)
          build_card_dummy(card.name, comments: resolved_comment_texts, desc: resolved_description)
        end

        private

        def substitute_anaphoras_in_comment(comment)
          comment.text.gsub(/(?<!\w)@[0-z]+/) do |match_string|
            user_full_name_by_username(match_string)
          end
        end

        def substitute_anaphoras_in_description(description)
          description.gsub(/(?<!\w)@[0-z]+/) do |match_string|
            user_full_name_by_username(match_string)
          end
        end

        def user_full_name_by_username(username)
          username_without_at = username[1..-1]
          user = board_members.find { |m| m.username == username_without_at }
          user.try(&:full_name) || ""
        end

        def board_members
          @board_members ||= card.board.members || []
        end
      end  
    end
  end
end
