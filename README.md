# [Falcon][gem_page]

[![Build Status][travis_status_image]][travis_page]
[![Maintainability][code_climate_maintainability_image]][code_climate_maintainability_page]
[![Test Coverage][code_climate_test_coverage_image]][code_climate_test_coverage_page]

An easy and customisable http client using Faraday

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'falcon', github: 'petlove/falcon'
```

and run:

```
rails falcon:install
```

## Settings
Set the settings in the file _config/initializers/falcon.rb_:

```ruby
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
```

## Using

To use this gem, you can extend the module `Falcon::Client` and set the options. You could set the options before through the method `falcon_options` or direct in the request method, like:

```ruby
# frozen_string_literal: true

module Cloudflare
  module Resources
    class DnsRecord
      class RecordAlreadyExistError < StandardError; end
      extend Falcon::Client

      RECORD_ALREADY_EXIST_ERROR_MESSAGE = 'The record already exists.'

      falcon_options raise_error: true,
                     url: 'https://api.cloudflare.com/client/v4/',
                     path: "zones/#{ENV['CLOUDFLARE_WHITELABEL_ZONE_ID']}/dns_records",
                     headers: {
                       'Content-Type' => 'application/json',
                       'Authorization' => ENV['CLOUDFLARE_API_TOKEN']
                     }

      ## If you add the option in the initilializer you can do it:
      ## falcon_options :cloudflare

      ## If you want to customize the option saved you cad do it:
      ## falcon_options :cloudflare, suffix: 20, raise_error: false

      class << self
        def find!(name)
          get(params: { name: name }, merge_in_headers: { user_token: 'blablabla' })
        end

        def create!(dns_record)
          post(
            payload: dns_record.as_json(only: %w[name type content]),
            after: ->(response) { handle_errors(response) unless response.success? }
          )
        end

        def update!(dns_record)
          put(
            suffix: dns_record.id,
            payload: dns_record.as_json(only: %w[name type content]),
            after: ->(response) { handle_errors(response) unless response.success? }
          )
        end

        def destroy!(dns_record)
          delete(suffix: dns_record.id)
        end

        private

        def handle_errors(response)
          raise RecordAlreadyExistError if record_already_exist?(response.body)
        end

        def record_already_exist?(body)
          body.dig(:errors)&.find { |error| error[:message] == RECORD_ALREADY_EXIST_ERROR_MESSAGE }
        end
      end
    end
  end
end
```

## Methods

Are available this HTTP methods:
* GET
* POST
* PUT
* DELETE

## Options

Are available this options:

| name | kind | how it works |
|------|------|--------------|
| `raise_error` | boolean | If true and if the request results in a failure will be raised a `Falcon::Error` with the original faraday error in response |
| `url` | string | The url that you want to request. It'll be joined to make uri |
| `path` | string | The resource that you want to request. It'll be joined to make uri |
| `suffix` | string | If you want to put a suffix like an id you can use this option. It'll be joined to make uri |
| `params` | hash | The query params that you want to pass. It'll be joined to make uri |
| `headers` | hash | The headers that you want to pass |
| `payload` | hash | The payload that you want to pass |
| `after` | `Proc` or `Lambda` | The action after the request using the response to handle what do you want (if you wanna handle something). If the result is a valid value (neither nil nor false) and the request raises an error, the after action will rescue the request, so, this request wont raise an error and returns an instance of `Falcon::Response` |

## Response

When the request doesn't have an error is returned an instance of `Falcon::Response`. This instance has the follow methods:

| name | kind | how it works |
|------|------|--------------|
| `success?` | boolean | If the request had a success it returns true |
| `code` | integer | The request's HTTP code of the request |
| `body` | hash (symbolized) | The request's response body |
| `original` | `Faraday::Response` or `Faraday::ClientError` | The original request's faraday response |

## Error

When is raised an error the error is an instance of `Falcon::Error`. This instance has the follow methods:

| name | kind | how it works |
|------|------|--------------|
| `response` | `Falcon::Response` | The response |

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License][mit_license_page].

[gem_page]: https://github.com/petlove/falcon
[code_of_conduct_page]: https://github.com/petlove/falcon/blob/master/CODE_OF_CONDUCT.md
[mit_license_page]: https://opensource.org/licenses/MIT
[contributor_convenant_page]: http://contributor-covenant.org
[travis_status_image]: https://travis-ci.org/petlove/falcon.svg?branch=master
[travis_page]: https://travis-ci.org/petlove/falcon
[code_climate_maintainability_image]: https://api.codeclimate.com/v1/badges/18ea24b096655a4f44c6/maintainability
[code_climate_maintainability_page]: https://codeclimate.com/github/petlove/falcon/maintainability
[code_climate_test_coverage_image]: https://api.codeclimate.com/v1/badges/18ea24b096655a4f44c6/test_coverage
[code_climate_test_coverage_page]: https://codeclimate.com/github/petlove/falcon/test_coverage
