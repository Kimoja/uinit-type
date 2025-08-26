# frozen_string_literal: true

module Uinit
  module Type
    class Composition < Base
      INTERSECTION = '&'
      UNION = '|'

      def initialize(operand, compositions = [])
        super()

        @operand = ::Uinit::Type.from(operand)
        @compositions = compositions
      end

      attr_reader :operand, :compositions

      def &(other)
        clone.add_intersection_composition(other)
      end

      def |(other)
        clone.add_union_composition(other)
      end

      def add_intersection_composition(operand)
        add_composition(INTERSECTION, operand)
      end

      def add_union_composition(operand)
        add_composition(UNION, operand)
      end

      def is?(value)
        is = operand.is?(value)

        compositions.each do |operator, operand|
          break if is && operator == UNION
          next if !is && operator == INTERSECTION

          is = operand.is?(value)
        end

        is
      end

      # rubocop:disable Metrics/PerceivedComplexity
      def check!(value, depth)
        errors = []
        is = true

        begin
          operand.check!(value, depth + 1)
        rescue Error => e
          errors << e
          is = false
        end

        compositions.each do |operator, operand|
          break if is && operator == UNION
          next if !is && operator == INTERSECTION

          begin
            operand.check!(value, depth + 1)
            is = true
          rescue Error => e
            errors << e
            is = false
          end
        end

        return value if is

        type_error!(value, errors.max_by(&:depth))
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def inspect
        "(#{[operand, *compositions.flatten].join(' ')})"
      end

      private

      def add_composition(operator, operand)
        compositions << [operator, ::Uinit::Type.from(operand)]

        self
      end

      def clone
        Composition.new(operand, compositions.dup)
      end

      def type_error!(value, deepest_error)
        error_message =
          if deepest_error.types.first.is_a?(Composition)
            deepest_error.error_message
          else
            "#{value.inspect}: No type composition matches\nDeepest error: #{deepest_error.error_message}"
          end

        raise Error.new(
          error_message,
          [self] + deepest_error.types.dup,
          deepest_error.depth,
          deepest_error.traces
        )
      end
    end
  end
end
