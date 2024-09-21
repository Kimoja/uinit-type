# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'uinit/type/version'

Gem::Specification.new do |spec|
  spec.name = 'uinit-type'
  spec.version = Uinit::Type::VERSION
  spec.authors = ['Kimoja']
  spec.email = ['joakim.carrilho@cheerz.com']

  spec.summary = 'Dynamic type checker'
  spec.description = 'Dynamic type checker'
  spec.homepage = 'https://github.com/Kimoja/uinit-type'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.1'
  spec.files = Dir['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'uinit-type.gemspec', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.executables = []

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['source_code_uri'] = 'https://github.com/Kimoja/uinit-type'
  spec.metadata['changelog_uri'] = 'https://github.com/Kimoja/uinit-type/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/Kimoja/uinit-type/issues'

  spec.add_runtime_dependency 'zeitwerk', '~> 2.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
