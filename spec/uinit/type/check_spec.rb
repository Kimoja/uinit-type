# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Check do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) { described_class[proc { _1.start_with?('ok') }] }
    let(:val) { nil }

    context 'when not check proc' do
      let(:val) { 'not ok' }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when check proc' do
      let(:val) { 'ok !' }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) { described_class[proc { _1.start_with?('ok') }] }
    let(:val) { nil }

    context 'when not check proc' do
      let(:val) { 'not ok' }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /does not respect rule specified in/)
      end
    end

    context 'when check proc' do
      let(:val) { 'ok !' }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end
  end
end
