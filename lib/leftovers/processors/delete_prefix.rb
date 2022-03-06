# frozen_string_literal: true

module Leftovers
  module Processors
    class DeletePrefix
      include ComparableInstance

      def initialize(prefix, then_processor)
        @prefix = prefix
        @then_processor = then_processor

        freeze
      end

      def process(str, current_node, matched_node, acc)
        return unless str

        @then_processor.process(str.delete_prefix(@prefix), current_node, matched_node, acc)
      end

      freeze
    end
  end
end
