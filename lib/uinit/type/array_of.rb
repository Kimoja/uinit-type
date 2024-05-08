# frozen_string_literal: true

module Uinit
  module Type
    class ArrayOf < Generic
      def self.from?(array)
        array.is_a?(Array)
      end

      def self.from(array)
        new(array.first) if from?(array)
      end

      def is?(value)
        return false unless value.is_a?(Array)

        value.all? { |val| type.is?(val) }
      end

      def check!(value, depth)
        type_error!("#{value.inspect} must be an Array", depth) unless value.is_a?(Array)

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
