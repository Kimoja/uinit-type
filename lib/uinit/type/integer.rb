# frozen_string_literal: true

module Uinit
  module Type
    class Integer < TypeOf
      def initialize(min: nil, max: nil, positive: nil, negative: nil, zero: nil)
        super(::Integer)

        @min = min
        @max = max
        @positive = positive
        @negative = negative
        @zero = zero
      end

      attr_reader :min, :max, :positive, :negative, :zero

      # rubocop:disable Metrics/PerceivedComplexity
      def is?(value)
        return false unless super

        return false if min && value < min
        return false if max && value > max
        return false if positive == false && value.positive?
        return false if positive == true && value <= 0
        return false if negative == false && value.negative?
        return false if negative == true && value >= 0
        return false if zero == false && value.zero?
        return false if zero == true && !value.zero?

        true
      end

      def check!(value, depth)
        type_error!("Integer too small (minimum #{min})", depth) if min && value < min
        type_error!("Integer too large (maximum #{max})", depth) if max && value > max
        type_error!('Integer cannot be positive', depth) if positive == false && value.positive?
        type_error!('Integer must be positive', depth) if positive == true && value <= 0
        type_error!('Integer cannot be negative', depth) if negative == false && value.negative?
        type_error!('Integer must be negative', depth) if negative == true && value >= 0
        type_error!('Integer cannot be zero', depth) if zero == false && value.zero?
        type_error!('Integer must be zero', depth) if zero == true && !value.zero?

        value
      end
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
