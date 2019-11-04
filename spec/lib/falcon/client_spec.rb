# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Falcon::Client, type: :module do
  describe '#falcon_default_options' do
    class FalconClientFalconDefaulOptions
      extend Falcon::Client

      falcon_options raise_error: true,
                     url: 'https://www.petlove.com.br',
                     path: '/mini-adulto-cao-adulto-pequeno-porte-royal-canin/p',
                     headers: { 'Content-Type' => 'application/json' },
                     params: { brand: 'royal canin', size: 'p' },
                     payload: { weigth: 7.5, promotion: false }
    end

    subject { FalconClientFalconDefaulOptions.falcon_default_options }

    it do
      is_expected.to have_attributes(
        raise_error: true,
        url: 'https://www.petlove.com.br',
        path: '/mini-adulto-cao-adulto-pequeno-porte-royal-canin/p',
        headers: { 'Content-Type' => 'application/json' },
        params: { brand: 'royal canin', size: 'p' },
        payload: { weigth: 7.5, promotion: false }
      )
    end
  end

  describe '#get', :vcr do
    class FalconClientGet
      extend Falcon::Client

      falcon_options raise_error: true,
                     url: 'https://api.cloudflare.com/client/v4/',
                     path: "zones/#{ENV['CLOUDFLARE_WHITELABEL_ZONE_ID']}/dns_records",
                     headers: {
                       'Content-Type' => 'application/json'
                     }
    end

    subject { FalconClientGet.get(options) }

    context 'with error' do
      context 'without raise error option' do
        let(:options) do
          {
            raise_error: false,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it { is_expected.to be_a(Falcon::Response) }
        it { expect(subject.success?).to be_falsey }
        it { expect(subject.code).to eq(403) }
        it do
          expect(subject.body).to eq(
            errors: [
              { code: 9106, message: 'Missing X-Auth-Email header' },
              { code: 9107, message: 'Missing X-Auth-Key header' }
            ],
            messages: [],
            result: nil,
            success: false
          )
        end
      end

      context 'with raise error option' do
        context 'without after' do
          let(:options) { { headers: { 'Content-Type' => 'application/json' } } }

          it { expect { subject }.to raise_error(Falcon::Error) }
        end

        context 'with after' do
          context 'when after returns a nil value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { nil }
              }
            end

            it { expect { subject }.to raise_error(Falcon::Error) }
          end

          context 'when after raise another error' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { raise NotImplementedError }
              }
            end

            it { expect { subject }.to raise_error(NotImplementedError) }
          end

          context 'when after does not return a nil or false value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { true }
              }
            end

            it { is_expected.to be_a(Falcon::Response) }
            it { expect(subject.success?).to be_falsey }
            it { expect(subject.code).to eq(403) }
            it do
              expect(subject.body).to eq(
                errors: [
                  { code: 9106, message: 'Missing X-Auth-Email header' },
                  { code: 9107, message: 'Missing X-Auth-Key header' }
                ],
                messages: [],
                result: nil,
                success: false
              )
            end
          end
        end
      end
    end

    context 'without error' do
      let(:options) do
        {
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{ENV['CLOUDFLARE_API_TOKEN']}"
          }
        }
      end

      it { is_expected.to be_a(Falcon::Response) }
      it { expect(subject.success?).to be_truthy }
      it { expect(subject.code).to eq(200) }
    end
  end

  describe '#post', :vcr do
    class FalconClientPost
      extend Falcon::Client

      falcon_options raise_error: true,
                     url: 'https://api.cloudflare.com/client/v4/',
                     path: "zones/#{ENV['CLOUDFLARE_WHITELABEL_ZONE_ID']}/dns_records",
                     headers: {
                       'Content-Type' => 'application/json'
                     }
    end

    subject { FalconClientPost.post(options) }

    context 'with error' do
      context 'without raise error option' do
        let(:options) do
          {
            raise_error: false,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it { is_expected.to be_a(Falcon::Response) }
        it { expect(subject.success?).to be_falsey }
        it { expect(subject.code).to eq(403) }
        it do
          expect(subject.body).to eq(
            errors: [
              { code: 9106, message: 'Missing X-Auth-Email header' },
              { code: 9107, message: 'Missing X-Auth-Key header' }
            ],
            messages: [],
            result: nil,
            success: false
          )
        end
      end

      context 'with raise error option' do
        context 'without after' do
          let(:options) { { headers: { 'Content-Type' => 'application/json' } } }

          it { expect { subject }.to raise_error(Falcon::Error) }
        end

        context 'with after' do
          context 'when after returns a nil value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { nil }
              }
            end

            it { expect { subject }.to raise_error(Falcon::Error) }
          end

          context 'when after raise another error' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { raise NotImplementedError }
              }
            end

            it { expect { subject }.to raise_error(NotImplementedError) }
          end

          context 'when after does not return a nil or false value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { true }
              }
            end

            it { is_expected.to be_a(Falcon::Response) }
            it { expect(subject.success?).to be_falsey }
            it { expect(subject.code).to eq(403) }
            it do
              expect(subject.body).to eq(
                errors: [
                  { code: 9106, message: 'Missing X-Auth-Email header' },
                  { code: 9107, message: 'Missing X-Auth-Key header' }
                ],
                messages: [],
                result: nil,
                success: false
              )
            end
          end
        end
      end
    end

    context 'without error' do
      let(:options) do
        {
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{ENV['CLOUDFLARE_API_TOKEN']}"
          },
          payload: {
            name: 'linqueta01',
            type: 'A',
            content: ENV['CLOUDFLARE_SERVICE_IP'],
            proxied: true
          }
        }
      end

      it { is_expected.to be_a(Falcon::Response) }
      it { expect(subject.success?).to be_truthy }
      it { expect(subject.code).to eq(200) }
    end
  end

  describe '#put', :vcr do
    class FalconClientPut
      extend Falcon::Client

      falcon_options raise_error: true,
                     url: 'https://api.cloudflare.com/client/v4/',
                     path: "zones/#{ENV['CLOUDFLARE_WHITELABEL_ZONE_ID']}/dns_records/38e6f20282615d309018ca4edb56f8d7",
                     headers: {
                       'Content-Type' => 'application/json'
                     }
    end

    subject { FalconClientPut.put(options) }

    context 'with error' do
      context 'without raise error option' do
        let(:options) do
          {
            raise_error: false,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it { is_expected.to be_a(Falcon::Response) }
        it { expect(subject.success?).to be_falsey }
        it { expect(subject.code).to eq(403) }
        it do
          expect(subject.body).to eq(
            errors: [
              { code: 9106, message: 'Missing X-Auth-Email header' },
              { code: 9107, message: 'Missing X-Auth-Key header' }
            ],
            messages: [],
            result: nil,
            success: false
          )
        end
      end

      context 'with raise error option' do
        context 'without after' do
          let(:options) { { headers: { 'Content-Type' => 'application/json' } } }

          it { expect { subject }.to raise_error(Falcon::Error) }
        end

        context 'with after' do
          context 'when after returns a nil value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { nil }
              }
            end

            it { expect { subject }.to raise_error(Falcon::Error) }
          end

          context 'when after raise another error' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { raise NotImplementedError }
              }
            end

            it { expect { subject }.to raise_error(NotImplementedError) }
          end

          context 'when after does not return a nil or false value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { true }
              }
            end

            it { is_expected.to be_a(Falcon::Response) }
            it { expect(subject.success?).to be_falsey }
            it { expect(subject.code).to eq(403) }
            it do
              expect(subject.body).to eq(
                errors: [
                  { code: 9106, message: 'Missing X-Auth-Email header' },
                  { code: 9107, message: 'Missing X-Auth-Key header' }
                ],
                messages: [],
                result: nil,
                success: false
              )
            end
          end
        end
      end
    end

    context 'without error' do
      let(:options) do
        {
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{ENV['CLOUDFLARE_API_TOKEN']}"
          },
          payload: {
            name: 'linqueta01',
            type: 'A',
            content: ENV['CLOUDFLARE_SERVICE_IP'],
            proxied: false
          }
        }
      end

      it { is_expected.to be_a(Falcon::Response) }
      it { expect(subject.success?).to be_truthy }
      it { expect(subject.code).to eq(200) }
    end
  end

  describe '#delete', :vcr do
    class FalconClientDelete
      extend Falcon::Client

      falcon_options raise_error: true,
                     url: 'https://api.cloudflare.com/client/v4/',
                     path: "zones/#{ENV['CLOUDFLARE_WHITELABEL_ZONE_ID']}/dns_records/38e6f20282615d309018ca4edb56f8d7",
                     headers: {
                       'Content-Type' => 'application/json'
                     }
    end

    subject { FalconClientDelete.delete(options) }

    context 'with error' do
      context 'without raise error option' do
        let(:options) do
          {
            raise_error: false,
            headers: { 'Content-Type' => 'application/json' }
          }
        end

        it { is_expected.to be_a(Falcon::Response) }
        it { expect(subject.success?).to be_falsey }
        it { expect(subject.code).to eq(403) }
        it do
          expect(subject.body).to eq(
            errors: [
              { code: 9106, message: 'Missing X-Auth-Email header' },
              { code: 9107, message: 'Missing X-Auth-Key header' }
            ],
            messages: [],
            result: nil,
            success: false
          )
        end
      end

      context 'with raise error option' do
        context 'without after' do
          let(:options) { { headers: { 'Content-Type' => 'application/json' } } }

          it { expect { subject }.to raise_error(Falcon::Error) }
        end

        context 'with after' do
          context 'when after returns a nil value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { nil }
              }
            end

            it { expect { subject }.to raise_error(Falcon::Error) }
          end

          context 'when after raise another error' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { raise NotImplementedError }
              }
            end

            it { expect { subject }.to raise_error(NotImplementedError) }
          end

          context 'when after does not return a nil or false value' do
            let(:options) do
              {
                headers: { 'Content-Type' => 'application/json' },
                after: ->(_response) { true }
              }
            end

            it { is_expected.to be_a(Falcon::Response) }
            it { expect(subject.success?).to be_falsey }
            it { expect(subject.code).to eq(403) }
            it do
              expect(subject.body).to eq(
                errors: [
                  { code: 9106, message: 'Missing X-Auth-Email header' },
                  { code: 9107, message: 'Missing X-Auth-Key header' }
                ],
                messages: [],
                result: nil,
                success: false
              )
            end
          end
        end
      end
    end

    context 'without error' do
      let(:options) do
        {
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{ENV['CLOUDFLARE_API_TOKEN']}"
          }
        }
      end

      it { is_expected.to be_a(Falcon::Response) }
      it { expect(subject.success?).to be_truthy }
      it { expect(subject.code).to eq(200) }
    end
  end
end
