# frozen_string_literal: true

module Uinit
  module Type
    class SetOf < Generic
      def self.from?(set)
        set.is_a?(::Set)
      end

      def self.from(set)
        new(set.first) if from?(set)
      end

      def is?(value)
        return false unless value.is_a?(::Set)

        value.all? do |val|
          type.is?(val)
        end
      end

      def check!(value, depth)
        type_error!("#{value.inspect} must be a Set", depth) unless value.is_a?(::Set)

        value.each_with_index do |val, index|
          type.check!(val, depth + 1)
        rescue Error => e
          trace!(e, "[#{index}]")
        end

        value
      end
    end
  end
end
