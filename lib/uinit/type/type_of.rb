# frozen_string_literal: true

module Uinit
  module Type
    class TypeOf < Base
      def self.from?(class_module)
        class_module.is_a?(::Class) || class_module.is_a?(::Module)
      end

      def self.from(class_module)
        new(class_module) if from?(class_module)
      end

      def initialize(class_module)
        super()

        raise ArgumentError, 'class_module must be a Class or a Module' unless self.class.from?(class_module)

        @class_module = class_module
      end

      attr_reader :class_module

      def is?(value)
        value.is_a?(class_module)
      end

      def check!(value, depth)
        return value if is?(value)

        type_error!("#{value.inspect} must be an instance of #{class_module}", depth)
      end

      def inspect
        "#{super}[#{class_module.inspect}]"
      end
    end
  end
end
