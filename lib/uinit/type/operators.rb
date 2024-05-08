# frozen_string_literal: true

module Uinit
  module Type
    module Operators
      def &(other)
        Composition[self].add_intersection_composition(other)
      end

      def |(other)
        Composition[self].add_union_composition(other)
      end
    end
  end
end
