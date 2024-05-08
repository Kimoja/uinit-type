# frozen_string_literal: true

module Uinit
  module Type
    class Extend < Base
      def self.from?(value)
        value.is_a?(Class) || value.is_a?(Module)
      end

      def self.from(value)
        new(value) if from?(value)
      end

      # TODO: Allow to pass Fn
      def initialize(class_module)
        super()

        @class_module = class_module
      end

      attr_reader :class_module

      def is?(value)
        return false unless value.is_a?(Class) || value.is_a?(Module)

        value.ancestors.include?(class_module)
      end

      def check!(value, depth)
        unless value.is_a?(Class) || value.is_a?(Module)
          type_error!("#{value.inspect} is not a Class or a Module", depth)
        end

        return value if value.ancestors.include?(class_module)

        type_error!("#{value.inspect} does not extend #{class_module}", depth)
      end

      def inspect
        "#{super}[#{class_module.inspect}]"
      end
    end
  end
end
