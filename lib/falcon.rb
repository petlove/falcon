# frozen_string_literal: true

require 'falcon/version'
require 'falcon/options'
require 'falcon/configuration'
require 'falcon/response'
require 'falcon/error'
require 'falcon/client'

module Falcon
  require 'falcon/railtie' if defined?(Rails)

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
