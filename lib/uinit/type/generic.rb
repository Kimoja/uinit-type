# frozen_string_literal: true

module Uinit
  module Type
    class Generic < Base
      def initialize(type)
        super()

        @type = ::Uinit::Type.from(type)
      end

      attr_reader :type

      def inspect
        "#{super}[#{type.inspect}]"
      end
    end
  end
end
