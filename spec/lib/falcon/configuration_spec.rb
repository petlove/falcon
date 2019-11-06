# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Falcon::Configuration, type: :model do
  describe '#initialize' do
    subject { described_class.new }

    it { is_expected.to have_attributes(options: {}) }
  end

  describe '#add' do
    subject { instance.add(name, options) }

    let(:instance) { described_class.new }
    let(:name) { :parse }
    let(:options) do
      {
        raise_error: true,
        url: url,
        headers: {
          'Content-Type' => 'application/json',
          'X-Parse-Application-Id' => application_id,
          'X-Parse-REST-API-Key' => rest_api_key
        }
      }
    end
    let(:url) { 'https://parse.parseaccount.com.br/parse/users' }
    let(:application_id) { SecureRandom.uuid }
    let(:rest_api_key) { SecureRandom.uuid }

    before { subject }

    it { expect(instance.options).not_to be_empty }
    it do
      expect(instance.options[:parse]).to have_attributes(
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

  describe '#option' do
    subject { instance.option(name, options) }

    let(:instance) { described_class.new }
    let(:default_options) do
      {
        raise_error: true,
        url: 'https://parse.parseaccount.com.br',
        headers: {
          'Content-Type' => 'application/json',
          'X-Parse-Application-Id' => SecureRandom.uuid,
          'X-Parse-REST-API-Key' => SecureRandom.uuid
        },
        path: 'parse/users',
        params: { a: 'a' },
        payload: { b: 'b' },
        suffix: 10
      }
    end

    before { instance.add(:parse, default_options) }

    context 'without name and options' do
      let(:name) { nil }
      let(:options) { nil }

      it { is_expected.to be_a(Falcon::Options) }
      it do
        is_expected.to have_attributes(
          raise_error: nil,
          url: nil,
          headers: nil,
          path: nil,
          params: nil,
          payload: nil,
          after: nil,
          suffix: nil
        )
      end
    end

    context 'with just name' do
      let(:options) { nil }

      context 'when name is a hash' do
        let(:name) { default_options }

        it { is_expected.to be_a(Falcon::Options) }
        it { is_expected.to have_attributes(default_options) }
      end

      context 'when name is a string' do
        context 'when name does not exist' do
          let(:name) { :local }

          it { is_expected.to be_a(Falcon::Options) }
          it do
            is_expected.to have_attributes(
              raise_error: nil,
              url: nil,
              headers: nil,
              path: nil,
              params: nil,
              payload: nil,
              after: nil,
              suffix: nil
            )
          end
        end

        context 'when name does not exist' do
          let(:name) { :parse }

          it { is_expected.to be_a(Falcon::Options) }
          it { is_expected.to have_attributes(default_options) }
        end
      end
    end

    context 'with name and options' do
      let(:options) { { suffix: 20 } }

      context 'when name is a hash' do
        let(:name) { default_options }

        it { is_expected.to be_a(Falcon::Options) }
        it { is_expected.to have_attributes(default_options.merge(suffix: 20)) }
      end

      context 'when name is a string' do
        context 'when name does not exist' do
          let(:name) { :local }

          it { is_expected.to be_a(Falcon::Options) }
          it do
            is_expected.to have_attributes(
              raise_error: nil,
              url: nil,
              headers: nil,
              path: nil,
              params: nil,
              payload: nil,
              after: nil,
              suffix: 20
            )
          end
        end

        context 'when name does not exist' do
          let(:name) { :parse }

          it { is_expected.to be_a(Falcon::Options) }
          it { is_expected.to have_attributes(default_options.merge(suffix: 20)) }
        end
      end
    end
  end
end
