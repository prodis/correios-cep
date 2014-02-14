require 'correios-cep'
require 'vcr'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = "random"
end

VCR.configure do |config|
  config.default_cassette_options = { :match_requests_on => [:uri, :method, :body, :headers] }
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

