# frozen_string_literal: true

require 'statistic_calcs/distributions/continuous'

module StatisticCalcs
  module Distributions
    class FisherSnedecor < Continuous
      # d1, d2 > 0
      # x > 0 v.a.
      attr_accessor :d1, :d2, :x
      attr_alias :nu1, :d1
      attr_alias :nu2, :d2

      def calc!
        self.d1 = d1.to_f
        self.d2 = d2.to_f
        self.mean = d2 / (d2 - 2)
        self.variance = (2 * d2**2 * (d1 + d2 - 2)) / (d1 * (d2 - 2)**2 * (d2 - 4))
        super
      end

      private

      def gsl_f
        gsl_cdf.fdist_P(x, nu1, nu2)
      end

      def gsl_f_inv
        gsl_cdf.fdist_Pinv(f_x, nu1, nu2)
      end

      def gsl_g_inv
        gsl_cdf.fdist_Qinv(g_x, nu1, nu2)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
