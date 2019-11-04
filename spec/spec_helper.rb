# frozen_string_literal: true

require 'bundler/setup'
require 'support/configs/simple_cov_config'
require 'support/configs/vcr_config'

SimpleCovConfig.configure

require 'falcon'
require 'pry'

require 'dotenv'

Dotenv.load('.env.test')
VCRConfig.configure

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
