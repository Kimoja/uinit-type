# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Naming/MethodParameterName
# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe Uinit::Type::Impl do
  class TestOk
    def meth_a; end
    def meth_b(a, b); end
    def meth_c(*a); end
  end

  class TestKoA
    def meth_not_a; end
    def meth_b(a, b); end
    def meth_c(*a); end
  end

  class TestKoB
    def meth_a; end
    def meth_b(a, b, c); end
    def meth_c(ok); end
  end

  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) do
      described_class.new(
        :meth_a,
        meth_b: Uinit::Type::Fn.new(2),
        meth_c: Uinit::Type::Fn.new
      )
    end

    let(:val) { nil }

    context 'when not impl meth_a' do
      let(:val) { TestKoA.new }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when not impl meth_b' do
      let(:val) { TestKoB.new }

      it 'returns false' do
        expect(check).to be(false)
      end
    end

    context 'when all implemented' do
      let(:val) { TestOk.new }

      it 'returns true' do
        expect(check).to be(true)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) do
      described_class.new(
        :meth_a,
        meth_b: Uinit::Type::Fn.new(2),
        meth_c: Uinit::Type::Fn.new
      )
    end

    let(:val) { nil }

    context 'when not impl meth_a' do
      let(:val) { TestKoA.new }

      it 'raises' do
        expect { check }.to raise_error(Uinit::Type::Error, /do not implement :meth_a method/)
      end
    end

    context 'when not impl meth_b' do
      let(:val) { TestKoB.new }

      it 'raises' do
        expect do
          check
        end.to raise_error(Uinit::Type::Error, /does not respect expected arity 2, defined arity 3/)
      end
    end

    context 'when all implemented' do
      let(:val) { TestOk.new }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end
  end
end
# rubocop:enable Naming/MethodParameterName
# rubocop:enable Lint/ConstantDefinitionInBlock
