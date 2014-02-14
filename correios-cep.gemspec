lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'correios/cep/version'

Gem::Specification.new do |spec|
  spec.name          = "correios-cep"
  spec.version       = Correios::CEP::VERSION
  spec.authors       = ["Prodis a.k.a. Fernando Hamasaki de Amorim"]
  spec.email         = ["prodis@gmail.com"]
  spec.description   = %q{Correios CEP gets updated Brazilian address from a zipcode, directly from Correios database. No HTML parsers, no workarounds, no "gambis".}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/prodis/correios-cep"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "log-me",   "~> 0.0.4"
  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 2.14"
  spec.add_development_dependency "vcr",     "~> 2.8"
  spec.add_development_dependency "webmock", "~> 1.15.2"
end
