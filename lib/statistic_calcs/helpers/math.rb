# frozen_string_literal: true

module StatisticCalcs
  module Helpers
    class Math
      def self.factorial(value)
        # return factorial_aprox(value) if value.is_a?(Float)
        return GSL::Sf.gamma(value + 1) if value.is_a?(Float)
        GSL::Sf.fact(value)
      end

      def self.euler
        GSL::M_EULER
      end

      def self.pi
        GSL::M_PI
      end

      def self.e
        GSL::M_E
      end

      # better value with gamma
      # def factorial_aprox(value)
      #   Math.sqrt(GSL::M_PI) * (value / GSL::M_E)**value \
      #     * (((8 * value + 4) * value + 1) * value + 1.0 / 30.0)**(1.0 / 6.0)
      # end
    end
  end
end
