# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'correios/cep/version'

Gem::Specification.new do |spec|
  spec.name          = 'correios-cep'
  spec.version       = Correios::CEP::VERSION
  spec.author        = 'Fernando Hamasaki de Amorim'
  spec.email         = 'prodis@gmail.com'
  spec.summary       = 'Correios CEP gem finds updated Brazilian addresses by zipcode, directly from Correios database. No HTML parsers.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/prodis/correios-cep'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.add_dependency 'ox', '~> 2.13'
  spec.add_dependency 'http', '~> 4.3'

  spec.add_development_dependency 'coveralls', '~> 0.8.23'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'vcr', '~> 5.1'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
