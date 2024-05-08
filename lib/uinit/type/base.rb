# frozen_string_literal: true

module Uinit
  module Type
    class Base
      include Operators

      def self.from?(type)
        type.is_a?(Base)
      end

      def self.from(type)
        type if from?(type)
      end

      def self.[](...)
        new(...)
      end

      def type_error!(message, depth, trace = [])
        raise Error.new(message.to_s, [self], depth, trace)
      end

      def trace!(error, trace)
        error.trace(self, trace)

        raise error
      end

      def inspect
        "$#{self.class.name.split('::').last}"
      end

      def to_s
        inspect
      end

      def ==(other)
        inspect == other.inspect
      end

      def is!(value)
        check!(value, 0)
      rescue Error => e
        e.value = value
        raise
      end
    end
  end
end
