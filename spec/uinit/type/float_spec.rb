# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::Float do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    context 'with default options' do
      let(:type) { described_class.new }

      context 'when not a float' do
        let(:val) { 'hello' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when a valid float' do
        let(:val) { 3.14 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when zero float' do
        let(:val) { 0.0 }

        it 'returns true by default' do
          expect(check).to be(true)
        end
      end
    end

    context 'with finite: true' do
      let(:type) { described_class.new(finite: true) }

      context 'when finite float' do
        let(:val) { 3.14 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when infinity' do
        let(:val) { Float::INFINITY }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when NaN' do
        let(:val) { Float::NAN }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end

    context 'with min constraint' do
      let(:type) { described_class.new(min: 1.5) }

      context 'when value below minimum' do
        let(:val) { 1.0 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when value equals minimum' do
        let(:val) { 1.5 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with positive: true' do
      let(:type) { described_class.new(positive: true) }

      context 'when positive value' do
        let(:val) { 3.14 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when zero' do
        let(:val) { 0.0 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when negative value' do
        let(:val) { -3.14 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end

    context 'with precision constraint' do
      let(:type) { described_class.new(precision: 2) }

      context 'when precision within limit' do
        let(:val) { 3.14 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when precision exceeds limit' do
        let(:val) { 3.14159 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when integer (no decimals)' do
        let(:val) { 3.0 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with combined constraints' do
      let(:type) { described_class.new(min: 0.0, max: 100.0, positive: true, precision: 2) }

      context 'when all constraints met' do
        let(:val) { 50.25 }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when precision constraint violated' do
        let(:val) { 50.123 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end
  end

  describe '#check!' do
    subject(:check) { type.check!(val, 0) }

    context 'with finite: true' do
      let(:type) { described_class.new(finite: true) }

      context 'when infinity' do
        let(:val) { Float::INFINITY }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /Float must be finite \(not Infinity or NaN\)/)
        end
      end
    end

    context 'with min constraint' do
      let(:type) { described_class.new(min: 1.5) }

      context 'when value below minimum' do
        let(:val) { 1.0 }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /Float too small \(minimum 1.5\)/)
        end
      end
    end

    context 'with precision constraint' do
      let(:type) { described_class.new(precision: 2) }

      context 'when precision exceeds limit' do
        let(:val) { 3.14159 }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /Float exceeds maximum precision of 2 decimal places/)
        end
      end
    end

    context 'when valid' do
      let(:type) { described_class.new(min: 0.0, max: 100.0) }
      let(:val) { 50.5 }

      it 'returns the value' do
        expect(check).to eq(50.5)
      end
    end
  end
end
