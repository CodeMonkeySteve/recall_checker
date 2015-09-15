require 'bundler/setup'
Bundler.setup

require 'webmock/rspec'
require 'vcr'
require 'recall_checker'

RSpec.configure do |config|
  # some (optional) config here
end

VCR.configure do |config|
	config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock 
end
