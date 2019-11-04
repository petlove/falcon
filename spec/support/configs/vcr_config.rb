# frozen_string_literal: true

require 'vcr'
require 'webmock'
require 'dotenv'

class VCRConfig
  def self.configure
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = false
      config.cassette_library_dir = 'spec/cassettes'
      config.hook_into :webmock
      config.ignore_localhost = true
      config.configure_rspec_metadata!

      Dotenv.load.merge(Dotenv.load('.env.test')).each do |k, v|
        config.filter_sensitive_data("ENV[#{k}]") { v }
      end
    end
  end
end
