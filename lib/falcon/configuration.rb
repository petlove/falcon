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
      update_option(option_by_name(name), options)
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
  end
end
