# frozen_string_literal: true

module Uinit
  module Type
    class Const < Base
      def self.from?(_val)
        true
      end

      def self.from(val)
        new(val) if from?(val)
      end

      def initialize(value)
        super()

        @value = value
      end

      attr_reader :value

      def is?(value)
        self.value == value
      end

      def check!(value, depth)
        return value if is?(value)

        type_error!(
          "#{value.inspect} must be equal to #{self.value.inspect}",
          depth
        )
      end

      def inspect
        "#{super}[#{value.inspect}]"
      end
    end
  end
end
