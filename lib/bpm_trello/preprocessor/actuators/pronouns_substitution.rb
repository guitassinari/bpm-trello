# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class PronounsSubstitution < Base
        def run
          resolved_comment_texts = card.comments.map { |c| substitute_anaphoras_in_comment(c) }
          resolved_description = substitute_anaphoras_in_general_text(card.desc)
          resolved_checklists = card.checklists.map { |c| resolve_checklist(c) }
          build_card_dummy(card.name, comments: resolved_comment_texts, desc: resolved_description, checklists: resolved_checklists)
        end

        private

        def substitute_anaphoras_in_comment(comment)
          comment.text.gsub(/\bI'm\b/, "#{comment_author_name(comment)} is")
                      .gsub(/\bI am\b/, "#{comment_author_name(comment)} is")
                      .gsub(/\bI\b/, comment_author_name(comment))
                      .gsub(/\bwe're\b/i, "#{card_members_names} are")
                      .gsub(/\bwe\b/i, card_members_names)
        end

        def substitute_anaphoras_in_general_text(description)
          description.gsub(/\bI'm\b/, "#{card_creator.full_name} is")
                     .gsub(/\bI am\b/, "#{card_creator.full_name} is")
                     .gsub(/\bI\b/, card_creator.full_name)
                     .gsub(/\bwe're\b/i,"#{card_members_names} are")
                     .gsub(/\bwe\b/i, card_members_names)
        end

        def resolve_checklist(checklist)
          checklist.items.map do |item|
            substitute_anaphoras_in_general_text(item.name)
          end
        end

        def card_creator
          @card_creator = card.actions.first.member_creator
        end

        def comment_author_name(comment)
          comment.member_creator.full_name
        end

        def card_members_names
          @card_members_names ||= card.members.map(&:full_name).join(" and ")
        end
      end  
    end
  end
end
