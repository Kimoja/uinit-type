# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Fn do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) { described_class[1] }
    let(:val) { nil }

    context 'when not a fn' do
      let(:val) { 'not ok' }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when not respect arity' do
      let(:val) { proc {} }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when repect arity' do
      let(:val) { proc { |a| a } }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) { described_class[1] }
    let(:val) { nil }

    context 'when not a fn' do
      let(:val) { 'not ok' }

      it 'raises' do
        # check
        expect do
          check
        end.to raise_error(Uinit::Type::Error, /"not ok" must be an Proc a Method or a UnboundMethod/)
      end
    end

    context 'when not respect arity' do
      let(:val) { proc {} }

      it 'raises' do
        expect do
          check
        end.to raise_error(Uinit::Type::Error, / does not respect expected arity 1, defined arity 0/)
      end
    end

    context 'when repect arity' do
      let(:val) { proc { |a| a } }

      it 'does not raise' do
        check
        expect { check }.not_to raise_error
      end
    end
  end
end
