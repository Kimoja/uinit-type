# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Integer do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    context 'with default options' do
      let(:type) { described_class.new }

      context 'when not an integer' do
        let(:val) { 'hello' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when a valid integer' do
        let(:val) { 42 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when zero' do
        let(:val) { 0 }

        it 'returns true by default' do
          expect(check).to be(true)
        end
      end

      context 'when negative' do
        let(:val) { -5 }

        it 'returns true by default' do
          expect(check).to be(true)
        end
      end
    end

    context 'with min constraint' do
      let(:type) { described_class.new(min: 10) }

      context 'when value below minimum' do
        let(:val) { 5 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when value equals minimum' do
        let(:val) { 10 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when value above minimum' do
        let(:val) { 15 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with max constraint' do
      let(:type) { described_class.new(max: 100) }

      context 'when value above maximum' do
        let(:val) { 150 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when value equals maximum' do
        let(:val) { 100 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with positive: true' do
      let(:type) { described_class.new(positive: true) }

      context 'when positive value' do
        let(:val) { 5 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when zero' do
        let(:val) { 0 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when negative value' do
        let(:val) { -5 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end

    context 'with negative: true' do
      let(:type) { described_class.new(negative: true) }

      context 'when negative value' do
        let(:val) { -5 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when zero' do
        let(:val) { 0 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when positive value' do
        let(:val) { 5 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end

    context 'with zero: false' do
      let(:type) { described_class.new(zero: false) }

      context 'when zero' do
        let(:val) { 0 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when non-zero' do
        let(:val) { 5 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end
  end

  describe '#check!' do
    subject(:check) { type.check!(val, 0) }

    context 'with min constraint' do
      let(:type) { described_class.new(min: 10) }

      context 'when value below minimum' do
        let(:val) { 5 }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /Integer too small \(minimum 10\)/)
        end
      end
    end

    context 'with positive: true' do
      let(:type) { described_class.new(positive: true) }

      context 'when zero' do
        let(:val) { 0 }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /Integer must be positive/)
        end
      end
    end

    context 'when valid' do
      let(:type) { described_class.new(min: 1, max: 100) }
      let(:val) { 50 }

      it 'returns the value' do
        expect(check).to eq(50)
      end
    end
  end
end
