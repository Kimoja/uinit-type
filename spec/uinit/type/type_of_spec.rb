# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe Uinit::Type::TypeOf do
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

    context 'when include ModuleKo' do
      let(:val) { TestOk }

      it 'returns true' do
        expect(check).to be(true)
      end
    end

    context 'when include ModuleKo' do
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

    context 'when include ModuleOk' do
      let(:val) { TestOk }

      it 'does not raise' do
        expect { check }.not_to raise_error
      end
    end

    context 'when include ModuleKo' do
      let(:val) { TestKo }

      it 'raises' do
        expect do
          check
        end.to raise_error(Uinit::Type::Error, /TestKo does not extend or include or preprend ModuleOk/)
      end
    end
  end
end
# rubocop:enable Lint/ConstantDefinitionInBlock
