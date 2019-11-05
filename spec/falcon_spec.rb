# frozen_string_literal: true

require 'securerandom'

RSpec.describe Falcon, type: :module do
  it { expect(described_class::VERSION).not_to be_nil }

  describe '.configure' do
    subject do
      described_class.configure do |config|
        config.add :parse,
                   raise_error: true,
                   url: url,
                   headers: {
                     'Content-Type' => 'application/json',
                     'X-Parse-Application-Id' => application_id,
                     'X-Parse-REST-API-Key' => rest_api_key
                   }
      end
    end

    let(:url) { 'https://parse.parseaccount.com.br/parse/users' }
    let(:application_id) { SecureRandom.uuid }
    let(:rest_api_key) { SecureRandom.uuid }

    before { subject }

    it { expect(described_class.configuration.options.length).to eq(1) }
    it do
      expect(described_class.configuration.options[:parse]).to have_attributes(
        raise_error: true,
        url: url,
        headers: {
          'Content-Type' => 'application/json',
          'X-Parse-Application-Id' => application_id,
          'X-Parse-REST-API-Key' => rest_api_key
        }
      )
    end
  end

  describe '.configuration' do
    subject { described_class.configuration }

    it { is_expected.to be_a(described_class::Configuration) }
  end
end
