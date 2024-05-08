# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::HashOf do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) { described_class.new({ a: String, b: Integer, c: described_class.new({ d: String }) }) }
    let(:val) { nil }

    context 'when not a hash of' do
      let(:val) { { a: 123, b: 123, c: { d: 'ok' } } }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when nested not a hash of' do
      let(:val) { { a: 'ok', b: 123, c: { d: 123 } } }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when an hahs of' do
      let(:val) { { a: 'ok', b: 123, c: { d: 'ok' } } }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) { described_class.new({ a: String, b: Integer, c: described_class.new({ d: String }) }) }
    let(:val) { nil }

    context 'when not a hash of' do
      let(:val) { { a: 123, b: 123, c: { d: 'ok' } } }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /123 must be an instance of String/)
      end
    end

    context 'when nested not a hash of' do
      let(:val) { { a: 'ok', b: 123, c: { d: 123 } } }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /123 must be an instance of String/)
      end
    end

    context 'when a hash of' do
      let(:val) { { a: 'ok', b: 123, c: { d: 'ok' } } }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end
  end
end
