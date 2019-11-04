# frozen_string_literal: true

module Falcon
  class Error < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end
  end
end
