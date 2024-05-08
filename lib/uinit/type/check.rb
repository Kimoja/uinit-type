# frozen_string_literal: true

module Uinit
  module Type
    class Check < Base
      def self.from?(check)
        check.is_a?(Proc)
      end

      def self.from(check)
        new(check) if from?(check)
      end

      def initialize(check)
        super()

        raise ArgumentError, 'check must be a Proc' unless self.class.from?(check)

        @check = check
      end

      attr_reader :check

      def is?(value)
        res = check[value]

        res == true || res.nil?
      end

      def check!(value, depth)
        res = check[value]

        return value if res == true || res.nil?

        file, line = check.source_location

        type_error!(
          "#{value.inspect} does not respect rule specified in #{file}:#{line}",
          depth
        )
      end

      def inspect
        file, line = check.source_location

        "#{super}[#{file}:#{line}]"
      end
    end
  end
end
