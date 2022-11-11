# frozen_string_literal: true

module Leftovers
  module Processors
    module Eval
      def self.process(str, current_node, _matched_node, acc)
        return unless str
        return if str.empty?

        acc.collect_subfile(str, current_node.loc.expression)
      end

      freeze
    end
  end
end
