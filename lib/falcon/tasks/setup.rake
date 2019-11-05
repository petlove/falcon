# frozen_string_literal: true

require 'fileutils'

FALCON_INITILIAZER_FILE = 'config/initializers/falcon.rb'

namespace :falcon do
  desc 'Install Falcon'
  task :install do
    create_initializer
  end
end

def create_initializer
  FileUtils.mkdir_p(File.dirname(FALCON_INITILIAZER_FILE))
  File.open(FALCON_INITILIAZER_FILE, 'w') { |file| file << settings }
end

def settings
  <<~SETTINGS
    # frozen_string_literal: true

    Falcon.configure do |config|
      # config.add :option_name, option_params_hash
      # config.add :parse,
      #            raise_error: true,
      #            url: ENV['PARSE_URL'],
      #            header: {
      #              'Content-Type' => 'application/json',
      #              'X-Parse-Application-Id' => ENV['PARSE_APPLICATION_ID'],
      #              'X-Parse-REST-API-Key' => ENV['PARSE_REST_API_KEY']
      #            }
    end
  SETTINGS
end
