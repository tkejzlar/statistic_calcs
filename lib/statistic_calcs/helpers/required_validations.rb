# frozen_string_literal: true

module StatisticCalcs
  module Helpers
    module RequiredValidations
      @required_attributes ||= {}

      def self.included(klass)
        @required_attributes[klass.name] ||= []
        klass.extend(ClassMethods)
      end

      def self.set(class_name, list)
        @required_attributes[class_name] = list
      end

      def validate!
        super
        list = RequiredValidations.instance_variable_get(:@required_attributes)[self.class.name]
        list.each do |attribute|
          raise StandardError, "`#{attribute}` is required" unless send(attribute)
        end
      end

      module ClassMethods
        def required(list)
          RequiredValidations.set(name, [list].flatten)
        end
      end
    end
  end
end
