# frozen_string_literal: true

module Leftovers
  module Processors
    class DeleteSuffix
      include ComparableInstance

      def initialize(suffix, then_processor)
        @suffix = suffix
        @then_processor = then_processor

        freeze
      end

      def process(str, current_node, matched_node, acc)
        return unless str

        @then_processor.process(str.delete_suffix(@suffix), current_node, matched_node, acc)
      end

      freeze
    end
  end
end
