# frozen_string_literal: true

module StatisticCalcs
  module Helpers
    class GarciaEquation
      def self.calc!(a)
        (2.0 / 9 * (a + ((a**2 + 1)**0.5))**2).ceil
      end
    end
  end
end
