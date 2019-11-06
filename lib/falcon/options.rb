# frozen_string_literal: true

module Falcon
  class Options
    ACCESSORS = %i[raise_error url path headers params payload after suffix].freeze

    attr_accessor(*ACCESSORS)

    def initialize(options = {})
      attributes!(options)
    end

    def clone!(options)
      dup.tap { |instance| instance.attributes!(options) }
    end

    def uri
      [[@url, @path, @suffix].compact.join('/'), parsed_params].compact.join('?')
    end

    def after!(response)
      @after&.call(response)
    end

    def attributes!(options)
      options.to_h.slice(*ACCESSORS).each { |k, v| instance_variable_set("@#{k}", v) }
    end

    private

    def parsed_params
      return unless @params

      @params.map { |k, v| "#{k}=#{v}" }.join('&')
             .then { |joined| joined unless joined == '' }
    end
  end
end
