# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Falcon::Options, type: :model do
  describe '#initialize' do
    subject { described_class.new(options) }
    let(:options) do
      {
        raise_error: true,
        url: 'https://www.petlove.com.br',
        path: '/mini-adulto-cao-adulto-pequeno-porte-royal-canin/p',
        headers: { 'Content-Type' => 'application/json' },
        params: { brand: 'royal canin', size: 'p' },
        payload: { weigth: 7.5, promotion: false }
      }
    end

    it { is_expected.to have_attributes(options) }
  end

  describe '#clone!' do
    let(:instance) { described_class.new(options) }
    subject { instance.clone!(clone_options) }
    let(:options) do
      {
        raise_error: true,
        url: 'https://www.petlove.com.br',
        path: '/mini-adulto-cao-adulto-pequeno-porte-royal-canin/p',
        params: { brand: 'royal canin', size: 'p' },
        payload: { weigth: 7.5, promotion: false }
      }
    end
    let(:clone_options) { { params: { brand: 'premier', size: 'g' } } }

    it { expect(subject.object_id).not_to eq(instance.object_id) }
    it { is_expected.to have_attributes(options.merge(clone_options)) }
  end

  describe '#uri' do
    subject { described_class.new(options).uri }
    let(:options) do
      {
        url: 'https://www.petlove.com.br',
        path: 'porte-royal-canin/p',
        params: { brand: 'royal', size: 'p' }
      }
    end
    let(:uri) { 'https://www.petlove.com.br/porte-royal-canin/p?brand=royal&size=p' }

    it { is_expected.to eq(uri) }
  end
end
