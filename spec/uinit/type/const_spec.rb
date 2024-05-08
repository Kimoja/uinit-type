# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Const do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) { described_class['ok'] }
    let(:val) { nil }

    context 'when not check const' do
      let(:val) { 'not ok' }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when check const' do
      let(:val) { 'ok' }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) { described_class['ok'] }
    let(:val) { nil }

    context 'when not check const' do
      let(:val) { 'not ok' }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /must be equal to "ok"/)
      end
    end

    context 'when check const' do
      let(:val) { 'ok' }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end
  end
end
