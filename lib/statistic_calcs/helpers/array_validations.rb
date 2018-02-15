# frozen_string_literal: true

module StatisticCalcs
  module Helpers
    module ArrayValidations
      def validate!(attribute)
        values = send(attribute)
        raise StandardError, "#{attribute} is not a valid list of float" unless values&.kind_of?(Array) && values.all? { |i| i.is_a?(Numeric) }
        raise StandardError, "#{attribute} should have some values" unless values.any?
      end
    end
  end
end
