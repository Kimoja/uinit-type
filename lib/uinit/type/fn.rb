# frozen_string_literal: true

module Uinit
  module Type
    class Fn < Base
      # TODO: arguments
      def initialize(arity = -1)
        super()

        raise ArgumentError, 'arity must be an Integer' unless arity.is_a?(Integer)

        @arity = arity
      end

      attr_reader :arity

      def is?(value)
        return false unless value.is_a?(Proc) || value.is_a?(Method) || value.is_a?(UnboundMethod)

        return true if arity == -1 || value.arity == -1

        value.arity == arity
      end

      def check!(value, depth)
        unless value.is_a?(Proc) || value.is_a?(Method) || value.is_a?(UnboundMethod)
          type_error!("#{value.inspect} must be an Proc a Method or a UnboundMethod", depth)
        end

        return value if arity == -1 || value.arity == -1 || value.arity == arity

        type_error!(
          "#{value.inspect} does not respect expected arity #{arity}, defined arity #{value.arity}",
          depth
        )
      end

      def inspect
        "#{super}[arity = #{arity}]"
      end
    end
  end
end
