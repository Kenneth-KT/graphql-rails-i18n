# frozen_string_literal: true

require 'date'

Gem::Specification.new do |s|
  s.name        = 'graphql-rails-i18n'
  s.version     = '0.3'
  s.date        = Date.today.to_s
  s.summary     = 'Rails I18n plugin for GraphQL Ruby'
  s.description = 'Add @locale directive in your GraphQL API that integrates Rails I18n API'
  s.homepage    = 'http://github.com/Kenneth-KT/graphql-rails-i18n'
  s.authors     = ['Kenneth Law']
  s.email       = ['cyt05108@gmail.com']
  s.license     = 'MIT'

  s.files = Dir['lib/**/*']
  s.test_files = Dir['spec/**/*']

  s.add_development_dependency 'rubocop', '~> 0.49'
  s.add_development_dependency 'rspec', '~> 3.0'

  s.add_dependency 'graphql', '~> 1.9.4'
  s.add_dependency 'rails', '>= 2.2.0'
end
