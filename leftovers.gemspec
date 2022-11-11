# frozen_string_literal: true

lib = ::File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'leftovers/version'

::Gem::Specification.new do |spec|
  spec.name = 'leftovers'
  spec.version = ::Leftovers::VERSION
  spec.authors = ['Dana Sherson']
  spec.email = ['robot@dana.sh']

  spec.summary = 'Find unused methods and classes/modules'
  spec.homepage = 'http://github.com/robotdana/leftovers'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://github.com/robotdana/leftovers'
  spec.metadata['changelog_uri'] = 'http://github.com/robotdana/leftovers/blob/main/CHANGELOG.md'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.5.0'

  spec.files = ::Dir.glob('{lib,exe,docs}/**/{*,.*}') + %w{
    CHANGELOG.md
    Gemfile
    LICENSE.txt
    README.md
    leftovers.gemspec
  }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| ::File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'haml'
  spec.add_development_dependency 'pry', '~> 0.1'
  spec.add_development_dependency 'rake', '>= 13'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'ruby-prof'
  spec.add_development_dependency 'simplecov', '>= 0.18.5'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'slim'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'tty_string', '>= 0.2.1'

  spec.add_development_dependency 'spellr', '>= 0.8.1'
  spec.add_dependency 'fast_ignore', '>= 0.17.0'
  spec.add_dependency 'parallel'
  spec.add_dependency 'parser'
end
