# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe Uinit::Type::Extend do
  module ModuleOk; end

  module ModuleKo; end

  class TestOk
    include ModuleOk
  end

  class TestKo
    include ModuleKo
  end

  describe '#is?' do
    subject(:check) { type.is?(val) }

    let(:type) do
      described_class.new(ModuleOk)
    end

    let(:val) { nil }

    context 'when extends ModuleKo' do
      let(:val) { TestOk }

      it 'returns true' do
        expect(check).to be(true)
      end
    end

    context 'when extends ModuleKo' do
      let(:val) { TestKo }

      it 'returns false' do
        expect(check).to be(false)
      end
    end
  end

  describe '#is!' do
    subject(:check) { type.is!(val) }

    let(:type) do
      described_class.new(ModuleOk)
    end

    let(:val) { nil }

    context 'when extends ModuleOk' do
      let(:val) { TestOk }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end

    context 'when not impl meth_b' do
      let(:val) { TestKo }

      it 'raises' do
        expect do
          check
        end.to raise_error(Uinit::Type::Error, /TestKo does not extend ModuleOk/)
      end
    end
  end
end
# rubocop:enable Lint/ConstantDefinitionInBlock
