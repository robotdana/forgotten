# frozen_string_literal: true

require 'pathname'

module Leftovers
  module TodoReporter
    class << self
      def prepare
        return unless path.exist?

        puts "Removing previous #{path.basename} file"
        puts ''
        path.delete
      end

      def report(collection)
        path.write(generate_file_body(collection))
        report_instructions

        0
      end

      def report_success
        puts "No #{path.basename} file generated, everything is used"

        0
      end

      private

      def report_instructions
        puts <<~MESSAGE
          generated #{path.basename}.
          running leftovers again will read this file and not alert you to any unused items mentioned in it.

          commit this file so you/your team can gradually address these items while still having leftovers alert you to any newly unused items.
        MESSAGE
      end

      def path
        ::Leftovers.pwd.join('.leftovers_todo.yml')
      end

      def generate_file_body(collection)
        <<~YML.chomp
          #{generation_message.chomp}
          #
          #{resolution_instructions}
          #{todo_data(collection).chomp}
        YML
      end

      def generation_message
        <<~YML
          # This file was generated by `leftovers --write-todo`
          # Generated at: #{Time.now.utc.strftime('%F %T')} UTC
        YML
      end

      def resolution_instructions
        <<~YML
          # for instructions on how to address these
          # see #{::Leftovers.resolution_instructions_link}
        YML
      end

      def todo_data(collection)
        [
          list_data(
            :test_only, 'Only directly called in tests', collection.with_tests
          ),
          list_data(
            :keep, 'Not directly called at all', collection.without_tests
          )
        ].compact.join
      end

      def list_data(key, title, list)
        return if list.empty?

        <<~YML
          #{key}:
            # #{title}:
          #{print_definition_list(list)}

        YML
      end

      def print_definition_list(definition_list)
        definition_list.map { |definition| print_definition(definition) }.sort.join("\n")
      end

      def print_definition(definition)
        return print_definition_list(definition.definitions) if definition.is_a?(DefinitionSet)

        "  - #{definition.to_s.inspect} # #{definition.location_s} #{definition.source_line.strip}"
      end

      def puts(string)
        ::Leftovers.puts(string)
      end
    end
  end
end
