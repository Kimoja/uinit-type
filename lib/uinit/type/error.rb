# frozen_string_literal: true

module Uinit
  module Type
    class Error < TypeError
      def initialize(error_message, types, depth, trace = [])
        super()

        @error_message = error_message
        @types = types
        @depth = depth
        @traces = trace
      end

      attr_reader :error_message, :instance, :types, :depth, :traces
      attr_accessor :value

      def trace(type, trace)
        types.unshift(type)
        traces.unshift(trace)
      end

      def message
        msg = error_message

        msg =
          if types.size == 1
            "#{msg}\nType: #{types.first}"
          else
            "#{msg}\nTypes:\n  #{types * "\n  "}"
          end

        msg = "#{msg}\nTraces: #{traces.join}" unless traces.empty?

        msg = "#{msg}\nValue: #{value.inspect}" if value

        msg
      end
    end
  end
end
