# frozen_string_literal: true

require 'faraday'
require 'json'

module Falcon
  module Client
    def self.extended(base)
      base.define_singleton_method(:falcon_default_options) { Falcon.configuration.option(name, options) }
    end

    def falcon_options(name, options = {})
      define_singleton_method(:falcon_default_options) do
        @falcon_default_options ||= Falcon.configuration.option(name, options)
      end
    end

    def get(options = {})
      falcon_request(options, :get)
    end

    def post(options = {})
      falcon_request(options, :post)
    end

    def put(options = {})
      falcon_request(options, :put)
    end

    def delete(options = {})
      falcon_request(options, :delete)
    end

    private

    def build_request_options(options)
      return Options.new(options) unless falcon_default_options

      falcon_default_options.clone!(options)
    end

    def build_faraday_client(options)
      Faraday.new(options.uri) do |config|
        config.use(Faraday::Response::RaiseError) if options.raise_error
        config.headers = options.headers
        config.adapter(Faraday.default_adapter)
      end
    end

    def build_faraday_request(client, method, options)
      client.send(method) { |request| build_faraday_request_options(request, options) }
    end

    def build_faraday_request_options(request, options)
      request.body = options.payload.to_json if options.payload
    end

    def falcon_request(options, method)
      request_options = build_request_options(options)

      build_faraday_client(request_options)
        .then { |faraday_client| build_faraday_request(faraday_client, method, request_options) }
        .then { |original_response| Response.new(original_response) }
        .then { |response| request_options.after!(response) || response }
    rescue Faraday::Error => e
      original_response = Response.new(e)
      return original_response if request_options.after!(original_response)

      raise Error, original_response
    end
  end
end
