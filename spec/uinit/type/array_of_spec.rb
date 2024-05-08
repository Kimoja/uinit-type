# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::ArrayOf do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) { described_class[String] }
    let(:val) { nil }

    context 'when not an array of' do
      let(:val) { ['ok', 'ok', 123] }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when an array of' do
      let(:val) { %w[ok ok 123] }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) { described_class[String] }
    let(:val) { nil }

    context 'when not an array of' do
      let(:val) { ['ok', 'ok', 123] }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /123 must be an instance of String/)
      end
    end

    context 'when an array of' do
      let(:val) { %w[ok ok 123] }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end
  end
end
