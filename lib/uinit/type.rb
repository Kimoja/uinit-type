# frozen_string_literal: true

require 'zeitwerk'

module Uinit; end

Zeitwerk::Loader.for_gem.tap do |loader|
  loader.push_dir(__dir__, namespace: Uinit)
  loader.setup
end

module Uinit
  module Type
    def self.is?(type, value)
      from(type).is?(value)
    end

    def self.is!(type, value)
      from(type).is?(value)
    end

    def self.from(arg)
      klass =
        [Base, Instance, ArrayOf, SetOf, HashOf, Check, Const].find do |type_class|
          type_class.from?(arg)
        end

      klass.from(arg)
    end
  end
end

require_relative 'type/extensions'
