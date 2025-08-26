# frozen_string_literal: true

module Uinit
  module Type
    class String < TypeOf
      def initialize(empty: true, min_length: nil, max_length: nil, format: nil)
        super(::String)

        @empty = empty
        @min_length = min_length
        @max_length = max_length
        @format = format
      end

      attr_reader :empty, :min_length, :max_length, :format

      # rubocop:disable Metrics/PerceivedComplexity
      def is?(value)
        return false unless super

        return false if !empty && (value.empty? || value.match?(/^\s+$/))
        return false if min_length && value.length < min_length
        return false if max_length && value.length > max_length
        return false if format && !value.match?(format)

        true
      end

      def check!(value, depth)
        if !empty && (value.empty? || value.match?(/^\s+$/))
          type_error!('String cannot be empty or contain only whitespace', depth)
        end

        if min_length && value.length < min_length
          type_error!("String too short (minimum #{min_length} characters)", depth)
        end

        if max_length && value.length > max_length
          type_error!("String too long (maximum #{max_length} characters)", depth)
        end

        type_error!('String doesn\'t match required pattern', depth) if format && !value.match?(format)

        value
      end
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
