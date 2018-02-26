# frozen_string_literal: true

require 'statistic_calcs/distributions/continuous'

module StatisticCalcs
  module Distributions
    class Gamma < Continuous
      # a, b > 0
      # x > 0 -> v.a.
      attr_accessor :alpha, :beta, :x
      attr_alias :a, :alpha
      attr_alias :b, :beta

      def calc!
        self.mean = mean.to_f
        self.alpha = alpha.to_f
        self.mean = alpha / beta
        self.variance = alpha / beta**2
        super
      end

      private

      def gsl_f
        gsl_cdf.gamma_P(x, a, 1.0 / b)
      end

      def gsl_f_inv
        gsl_cdf.gamma_Pinv(f_x, a, 1.0 / b)
      end

      def gsl_g_inv
        gsl_cdf.gamma_Qinv(g_x, a, 1.0 / b)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
