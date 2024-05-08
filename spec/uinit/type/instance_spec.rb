# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Instance do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) { described_class[String] }
    let(:val) { nil }

    context 'when not an instance of' do
      let(:val) { 123 }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when an instance of' do
      let(:val) { 'ok' }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) { described_class[String] }
    let(:val) { nil }

    context 'when not an instance of' do
      let(:val) { 123 }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /123 must be an instance of String/)
      end
    end

    context 'when an instance of' do
      let(:val) { 'ok' }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end
  end
end
