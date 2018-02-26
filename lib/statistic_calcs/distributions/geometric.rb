# frozen_string_literal: true

require 'statistic_calcs/distributions/discrete'

module StatisticCalcs
  module Distributions
    class Geometric < Discrete
      # r -> V.A.
      attr_accessor :probability_of_success, :number_successes
      attr_alias :p, :probability_of_success
      attr_alias :r, :number_successes

      def calc!
        calculate_p! unless p
        self.mean = (1 - p) / p
        self.variance = (1 - p) / p**2
        super
      end

      private

      def calculate_p!
        raise 'Not implemented!'
      end

      def gsl_p
        gsl_ran.geometric_pdf(r + 1, p)
      end

      def gsl_f
        gsl_cdf.geometric_P(r + 1, p)
      end

      def gsl_g
        gsl_cdf.geometric_Q(r, p)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
