# frozen_string_literal: true

require 'fileutils'
::FileUtils.rm_rf(::File.join(__dir__, '..', 'coverage'))
require 'bundler/setup'

require 'simplecov' if ::ENV['COVERAGE']

require_relative '../lib/leftovers'
require 'timecop'

::RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable ::RSpec exposing methods globally on `::Module` and `main`
  config.disable_monkey_patching!
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
    c.max_formatted_output_length = 2000
  end
  require_relative './support/temp_file_helper'
  require_relative './support/cli_helper'

  config.after do
    Timecop.return
  end
end

::RSpec::Matchers.define_negated_matcher :exclude, :include
::RSpec::Matchers.define :have_definitions do |*expected|
  match do |actual|
    @actual = actual.definitions.compact.flat_map(&:names).uniq
    expect(@actual).to contain_exactly(*expected)
  end

  diffable
end
::RSpec::Matchers.define :have_non_test_definitions do |*expected|
  match do |actual|
    @actual = actual.definitions.compact.reject(&:test?).flat_map(&:names).uniq
    expect(@actual).to contain_exactly(*expected)
  end

  diffable
end

::RSpec::Matchers.define :have_test_only_definitions do |*expected|
  match do |actual|
    @actual = actual.definitions.compact.select(&:test?).flat_map(&:names).uniq
    expect(@actual).to contain_exactly(*expected)
  end

  diffable
end

::RSpec::Matchers.define :have_calls do |*expected|
  match do |actual|
    @actual = actual.calls.uniq
    expect(@actual).to contain_exactly(*expected)
  end

  diffable
end
::RSpec::Matchers.define :have_calls_including do |*expected|
  match do |actual|
    @actual = actual.calls.uniq
    expect(@actual).to include(*expected)
  end

  diffable
end
::RSpec::Matchers.define :have_calls_excluding do |*expected|
  match do |actual|
    @actual = actual.calls.uniq
    expect(@actual).to exclude(*expected)
  end

  diffable
end

::RSpec::Matchers.define :have_no_definitions do
  match do |actual|
    @actual = actual.definitions.compact
    expect(@actual).to be_empty
  end

  diffable
end

::RSpec::Matchers.define :have_no_non_test_definitions do
  match do |actual|
    @actual = actual.definitions.compact.reject(&:test?)
    expect(@actual).to be_empty
  end

  diffable
end

::RSpec::Matchers.define :have_no_test_only_definitions do
  match do |actual|
    @actual = actual.definitions.compact.select(&:test?)
    expect(@actual).to be_empty
  end

  diffable
end

::RSpec::Matchers.define :have_no_calls do
  match do |actual|
    @actual = actual.calls
    expect(@actual).to be_empty
  end

  diffable
end

::RSpec::Matchers.define :match_nested_object do |expected|
  match do |actual|
    @actual = actual
    expect(@actual.class).to eq expected.class
    @actual.instance_variables.each do |ivar|
      expect(@actual.instance_variable_get(ivar)).to match_nested_object(
        expected.instance_variable_get(ivar)
      )
    end
  end

  diffable
end
