# frozen_string_literal: true

module Uinit
  module Type
    class Float < TypeOf
      # rubocop:disable Metrics/ParameterLists
      def initialize(min: nil, max: nil, positive: nil, negative: nil, zero: nil, precision: nil, finite: true)
        super(::Float)

        @min = min
        @max = max
        @positive = positive
        @negative = negative
        @zero = zero
        @precision = precision
        @finite = finite
      end
      # rubocop:enable Metrics/ParameterLists

      attr_reader :min, :max, :positive, :negative, :zero, :precision, :finite

      # rubocop:disable Metrics/PerceivedComplexity
      def is?(value)
        return false unless super

        return false if finite && !value.finite?
        return false if min && value < min
        return false if max && value > max
        return false if positive == false && value.positive?
        return false if positive == true && value <= 0
        return false if negative == false && value.negative?
        return false if negative == true && value >= 0
        return false if zero == false && value.zero?
        return false if zero == true && !value.zero?
        return false if precision && !valid_precision?(value)

        true
      end

      def check!(value, depth)
        type_error!('Float must be finite (not Infinity or NaN)', depth) if finite && !value.finite?
        type_error!("Float too small (minimum #{min})", depth) if min && value < min
        type_error!("Float too large (maximum #{max})", depth) if max && value > max
        type_error!('Float cannot be positive', depth) if positive == false && value.positive?
        type_error!('Float must be positive', depth) if positive == true && value <= 0
        type_error!('Float cannot be negative', depth) if negative == false && value.negative?
        type_error!('Float must be negative', depth) if negative == true && value >= 0
        type_error!('Float cannot be zero', depth) if zero == false && value.zero?
        type_error!('Float must be zero', depth) if zero == true && !value.zero?

        if precision && !valid_precision?(value)
          type_error!("Float exceeds maximum precision of #{precision} decimal places", depth)
        end

        value
      end
      # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

      private

      def valid_precision?(value)
        return true if precision.nil?

        # Compter les décimales
        decimal_places = value.to_s.split('.').last&.length || 0
        decimal_places <= precision
      end
    end
  end
end
