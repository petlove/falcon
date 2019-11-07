# frozen_string_literal: true

module Falcon
  class Options
    ACCESSORS = %i[raise_error url path headers params payload after suffix].freeze

    attr_accessor(*ACCESSORS)

    def initialize(options = {})
      setup!(options)
    end

    def setup!(options)
      attributes!(options)
      helpers!(options)
    end

    def clone!(options)
      dup.tap { |instance| instance.setup!(options) }
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

    def helpers!(options)
      merge_in_headers(options) if options[:merge_in_headers]
    end

    private

    def parsed_params
      return unless @params

      @params.map { |k, v| "#{k}=#{v}" }.join('&')
             .then { |joined| joined unless joined == '' }
    end

    def merge_in_headers(options)
      (@headers ||= {}).merge!(options[:merge_in_headers])
    end
  end
end
