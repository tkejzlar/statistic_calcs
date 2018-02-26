# frozen_string_literal: true

require 'statistic_calcs/distributions/continuous'
require 'statistic_calcs/helpers/math'

module StatisticCalcs
  module Distributions
    class LogNormal < Continuous
      # x -> V.A.
      attr_accessor :zeta, :sigma, :x

      def calc!
        self.zeta = zeta.to_f
        self.sigma = sigma.to_f
        self.mean = Helpers::Math.e**(zeta + (sigma**2 / 2))
        self.variance = (Helpers::Math.e**(sigma**2) - 1) * Helpers::Math.e**(2 * zeta + (sigma**2))
        super
      end

      private

      def gsl_f
        gsl_cdf.lognormal_P(x, zeta, sigma)
      end

      def gsl_f_inv
        gsl_cdf.lognormal_Pinv(f_x, zeta, sigma)
      end

      def gsl_g_inv
        gsl_cdf.lognormal_Qinv(g_x, zeta, sigma)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
