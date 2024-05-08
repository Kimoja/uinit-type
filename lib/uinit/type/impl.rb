# frozen_string_literal: true

module Uinit
  module Type
    class Impl < Base
      # TODO: Allow to pass Fn
      def initialize(*sym_interface, **interface)
        super()

        sym_interface.each do |meth|
          next if meth.is_a?(Symbol)

          raise ArgumentError, "#{meth.inspect} must be a Symbol"
        end

        interface.each do |(meth, fn)|
          next if fn.nil? || fn.is_a?(Fn)

          raise ArgumentError, "#{meth.inspect} must be Fn or Nil"
        end

        @interface =
          sym_interface.each_with_object(interface.dup) do |meth, inter|
            inter[meth] = nil
          end
      end

      attr_reader :interface

      def is?(value)
        interface.all? do |(meth, fn)|
          is = value.respond_to?(meth)

          next is if !is || fn.nil?

          fn.is?(value.method(meth))
        end
      end

      def check!(value, depth)
        interface.each do |meth, fn|
          is = value.respond_to?(meth)

          type_error!("#{value.inspect} do not implement #{meth.inspect} method", depth) unless is

          next if fn.nil?

          begin
            fn.check!(value.method(meth), depth + 1)
          rescue Error => e
            trace!(e, ".#{meth}()")
          end
        end

        value
      end

      def inspect
        "#{super}[#{interface.inspect}]"
      end
    end
  end
end
