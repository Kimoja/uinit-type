# frozen_string_literal: true

module Uinit
  module Type
    class Schema < Base
      def self.from?(schema)
        schema.is_a?(Hash)
      end

      def self.from(schema)
        new(schema) if from?(schema)
      end

      def initialize(schema, strict: false)
        super()

        raise ArgumentError, 'schema must be a Hash' unless self.class.from?(schema)

        @schema =
          schema.transform_values do |type|
            ::Uinit::Type.from(type)
          end

        @strict = !!strict
      end

      attr_reader :schema, :strict

      def is?(value)
        return false unless value.is_a?(Hash)

        is =
          schema.all? do |key, type|
            type.is?(value[key])
          end

        return is unless strict

        extra = value.keys - schema

        extra.empty?
      end

      def check!(value, depth)
        type_error!("#{value.inspect} must be a Hash", depth) unless value.is_a?(Hash)

        schema.each do |key, type|
          type.check!(value[key], depth + 1)
        rescue Error => e
          trace!(e, "[#{key.inspect}]")
        end

        value
      end

      def inspect
        "#{super}[#{schema.inspect}]"
      end
    end
  end
end
