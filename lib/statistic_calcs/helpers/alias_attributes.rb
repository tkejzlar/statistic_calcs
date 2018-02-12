# frozen_string_literal: true

module StatisticCalcs
  module Helpers
    module AliasAttributes
      def self.included(base)
        base.extend ClassMethods
      end

      def initialize(args)
        args.each do |key, value|
          send("#{key}=", value) unless value.nil?
        end
      end

      def to_h
        instance_variables.each_with_object({}) do |var, hash|
          hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
        end
      end

      def to_s
        "#{self.class.name}: " +
          instance_variables
          .map { |var| "#{var.to_s.delete('@')} = #{instance_variable_get(var)}" }
          .join(', ')
      end

      module ClassMethods
        def attr_alias(new_attr, original)
          alias_method(new_attr, original) if method_defined? original
          new_writer = "#{new_attr}="
          original_writer = "#{original}="
          alias_method(new_writer, original_writer) if method_defined? original_writer
        end
      end
    end
  end
end
