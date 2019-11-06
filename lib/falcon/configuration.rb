# frozen_string_literal: true

module Falcon
  class Configuration
    attr_reader :options

    def initialize
      @options = {}
    end

    def add(name, options)
      return unless name && options

      @options.merge!(name => Options.new(options))
    end

    def option(name, options)
      option_by_name(name).then { |option| update_option(option, options || {}) }
                          .then { |option| apply_helpers(option, options || {}) }
    end

    private

    def option_by_name(name)
      name.is_a?(Hash) ? Options.new(name) : find_option(name)
    end

    def update_option(option, options)
      options.is_a?(Hash) && option.is_a?(Options) ? option.clone!(options) : option
    end

    def find_option(name)
      @options[name] || Options.new
    end

    def apply_helpers(option, options)
      option.tap do
        merge_in_headers(option, options)
      end
    end

    def merge_in_headers(option, options)
      (option.headers ||= {}).merge!(options[:merge_in_headers]) if options[:merge_in_headers]
    end
  end
end
