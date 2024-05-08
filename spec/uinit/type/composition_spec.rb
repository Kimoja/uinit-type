# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Composition do
  let(:type) do
    Integer | (String & (Uinit::Type::Check.new(
      proc { |value|
        value.start_with?('ok')
      }
    ) | Uinit::Type::Check.new(
      proc { |value|
        value.start_with?('super')
      }
    )))
  end

  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:val) { nil }

    context 'when integer' do
      let(:val) { 123 }

      it 'returns true' do
        expect(check).to be(true)
      end
    end

    context 'when string' do
      context 'when not check ok and super' do
        let(:val) { 'not ok' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when check ok' do
        let(:val) { 'ok' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when check super' do
        let(:val) { 'super' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:val) { nil }

    context 'when integer' do
      let(:val) { 123 }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end

    context 'when string' do
      context 'when not check ok and super' do
        let(:val) { 'not ok' }

        it 'returns false' do
          expect { check }.to raise_error(Uinit::Type::Error, /"not ok" does not respect rule specified/)
        end
      end

      context 'when check ok' do
        let(:val) { 'ok' }

        it 'does not raise' do
          expect { check }.not_to raise_error
        end
      end

      context 'when check super' do
        let(:val) { 'super' }

        it 'does not raise' do
          expect { check }.not_to raise_error
        end
      end
    end
  end
end
