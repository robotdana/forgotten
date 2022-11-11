# frozen_string_literal: true

module Leftovers
  module ProcessorBuilders
    class Each
      class << self
        def each_or_self(value, &block)
          case value
          when nil then nil
          when ::Array then build(value.map(&block))
          else build([yield(value)])
          end
        end

        def build(processors)
          processors = compact(processors)

          case processors.length
          # :nocov:
          when 0 then raise UnexpectedCase, "Unhandled value #{processors.inspect}"
          # :nocov:
          when 1 then processors.first
          else processor_class.new(processors)
          end
        end

        private

        def processor_class
          Processors::Each
        end

        def flatten(processors)
          case processors
          when Processors::Each, processor_class
            flatten(processors.processors)
          when ::Array
            processors.flat_map { |v| flatten(v) }
          when Processors::MatchCurrentNode, Processors::MatchMatchedNode
            flatten_matchers(processors)
          else
            [processors]
          end
        end

        def flatten_matchers(processor)
          then_processors = flatten(processor.then_processor)
          return [processor] if then_processors.length <= 1

          then_processors.map do |then_processor|
            processor.class.new(processor.matcher, then_processor)
          end
        end

        def compact_matchers_with_same_processor(matchers)
          matchers.group_by(&:then_processor).map do |then_processor, group|
            next group.first unless group.length > 1

            group.first.class.new(
              MatcherBuilders::Or.build(group.map(&:matcher)),
              then_processor
            )
          end
        end

        def compact_matchers_with_same_matcher(matchers)
          matchers.group_by(&:matcher).map do |matcher, group|
            next group.first unless group.length > 1

            group.first.class.new(matcher, build(group.map(&:then_processor)))
          end
        end

        def compact_matchers(matchers)
          return [] unless matchers

          matchers = compact_matchers_with_same_processor(matchers)
          compact_matchers_with_same_matcher(matchers)
        end

        def compact(processors)
          processors = flatten(processors).compact

          return processors if processors.length <= 1

          group = processors.group_by(&:class)

          compact_matchers(group.delete(Processors::MatchCurrentNode)) +
            compact_matchers(group.delete(Processors::MatchMatchedNode)) +
            group.values.flatten(1)
        end
      end
    end
  end
end
