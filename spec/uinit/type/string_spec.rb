# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Uinit::Type::String do
  describe '#is?' do
    subject(:check) { type.is?(val) }

    context 'with default options' do
      let(:type) { described_class.new }

      context 'when not a string' do
        let(:val) { 123 }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when a valid string' do
        let(:val) { 'hello' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when an empty string' do
        let(:val) { '' }

        it 'returns true by default' do
          expect(check).to be(true)
        end
      end
    end

    context 'with empty: false' do
      let(:type) { described_class.new(empty: false) }

      context 'when empty string' do
        let(:val) { '' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when whitespace only' do
        let(:val) { '   ' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when valid non-empty string' do
        let(:val) { 'hello' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with min_length' do
      let(:type) { described_class.new(min_length: 5) }

      context 'when string too short' do
        let(:val) { 'hi' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when string exact length' do
        let(:val) { 'hello' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when string longer' do
        let(:val) { 'hello world' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with max_length' do
      let(:type) { described_class.new(max_length: 5) }

      context 'when string too long' do
        let(:val) { 'hello world' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when string exact length' do
        let(:val) { 'hello' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end
    end

    context 'with format pattern' do
      let(:type) { described_class.new(format: /\A[a-z]+\z/) }

      context 'when string matches pattern' do
        let(:val) { 'hello' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when string does not match pattern' do
        let(:val) { 'Hello123' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end

    context 'with combined constraints' do
      let(:type) { described_class.new(min_length: 3, max_length: 10, format: /\A[A-Za-z]+\z/) }

      context 'when all constraints met' do
        let(:val) { 'Hello' }

        it 'returns true' do
          expect(check).to be(true)
        end
      end

      context 'when length constraint violated' do
        let(:val) { 'Hi' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end

      context 'when format constraint violated' do
        let(:val) { 'Hello123' }

        it 'returns false' do
          expect(check).to be(false)
        end
      end
    end
  end

  describe '#check!' do
    subject(:check) { type.check!(val, 0) }

    context 'with empty: false' do
      let(:type) { described_class.new(empty: false) }

      context 'when empty string' do
        let(:val) { '' }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /String cannot be empty or contain only whitespace/)
        end
      end
    end

    context 'with min_length' do
      let(:type) { described_class.new(min_length: 5) }

      context 'when string too short' do
        let(:val) { 'hi' }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /String too short \(minimum 5 characters\)/)
        end
      end
    end

    context 'with max_length' do
      let(:type) { described_class.new(max_length: 5) }

      context 'when string too long' do
        let(:val) { 'hello world' }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /String too long \(maximum 5 characters\)/)
        end
      end
    end

    context 'with format pattern' do
      let(:type) { described_class.new(format: /\A[a-z]+\z/) }

      context 'when string does not match pattern' do
        let(:val) { 'Hello123' }

        it 'raises with appropriate message' do
          expect { check }.to raise_error(Uinit::Type::Error, /String doesn't match required pattern/)
        end
      end
    end

    context 'when valid' do
      let(:type) { described_class.new(min_length: 3, max_length: 10) }
      let(:val) { 'hello' }

      it 'returns the value' do
        expect(check).to eq('hello')
      end
    end
  end
end
