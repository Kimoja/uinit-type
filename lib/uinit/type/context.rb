# frozen_string_literal: true

module Uinit
  module Type
    module Context
      Nil = Const[nil].freeze
      Boolean = (Const[true] | Const[false]).freeze
      Str = Instance[String].freeze
      Int = Instance[Integer].freeze
      Float = Instance[Float].freeze
      Hsh = Instance[Hash].freeze
      Arr = Instance[Array].freeze
      Sym = Instance[Symbol].freeze

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

      def hash_of(schema, strict: false)
        HashOf.new(schema, strict:)
      end

      def impl(*, **)
        Impl.new(*, **)
      end

      def instance(type)
        Instance.new(type)
      end

      def set_of(type) # rubocop:disable Naming/AccessorMethodName
        SetOf.new(type)
      end

      def extends(type)
        Extend.new(type)
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
