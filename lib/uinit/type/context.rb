# frozen_string_literal: true

module Uinit
  module Type
    module Context
      Nil = Const[nil].freeze
      Boolean = (Const[true] | Const[false]).freeze
      Str = String.freeze
      Sym = TypeOf[Symbol].freeze
      Int = Integer.freeze
      Float = Float.freeze
      Hsh = TypeOf[Hash].freeze
      Arr = TypeOf[Array].freeze

      def array_of(type)
        ArrayOf.new(type)
      end

      def any_of(const, *consts)
        consts.reduce(Const[const]) { |type, cst| type | Const[cst] }
      end

      def check(check = nil, &proc_check)
        Check.new(check || proc_check)
      end

      def const(const)
        Const.new(const)
      end

      def fn(arity = -1)
        Fn.new(arity)
      end

      def schema(schema, strict: false)
        Schema.new(schema, strict:)
      end

      def impl(*, **)
        Impl.new(*, **)
      end

      def set_of(type)
        SetOf.new(type)
      end

      def type(type = BasicObject)
        Type.new(type)
      end

      def type_of(type)
        TypeOf.new(type)
      end

      def nilable
        Nil
      end
      alias null nilable
      alias none nilable

      def boolean
        Boolean
      end
      alias bool boolean

      def string
        Str
      end
      alias str string

      def integer
        Int
      end
      alias int integer

      def float
        Float
      end

      def hash
        Hsh
      end

      def array
        Arr
      end

      def sym
        Sym
      end
    end
  end
end
