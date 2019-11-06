# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'falcon/version'

Gem::Specification.new do |spec|
  spec.name          = 'falcon'
  spec.version       = Falcon::VERSION
  spec.authors       = ['linqueta']
  spec.email         = ['lincolnrodrs@gmail.com']

  spec.summary       = 'A customizable http client using Faraday'
  spec.description   = 'A customizable http client using Faraday'
  spec.homepage      = 'https://https://github.com/petlove/falcon'
  spec.license       = 'MIT'

  spec.files         = Dir['{config,lib}/**/*', 'CHANGELOG.md', 'MIT-LICENSE', 'README.md']

  spec.add_dependency 'faraday', '>= 0.17.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'dotenv', '~> 2.7.5'
  spec.add_development_dependency 'pry-byebug', '>= 3.7.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '>= 0.74.0'
  spec.add_development_dependency 'rubocop-performance', '>= 1.4.1'
  spec.add_development_dependency 'simplecov', '>= 0.17.0'
  spec.add_development_dependency 'simplecov-console', '>= 0.5.0'
  spec.add_development_dependency 'vcr', '>= 5.0.0'
  spec.add_development_dependency 'webmock', '>= 3.7.6'
end
