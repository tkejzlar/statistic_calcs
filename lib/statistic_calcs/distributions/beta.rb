# frozen_string_literal: true

require 'statistic_calcs/distributions/continuous'

module StatisticCalcs
  module Distributions
    class Beta < Continuous
      # alpha > 0
      # beta > 0
      # 0 < x < 1
      # x -> V.A.
      attr_accessor :alpha, :beta, :x
      attr_alias :a, :alpha
      attr_alias :b, :beta

      def calc!
        self.alpha = alpha.to_f || 0
        self.mean = alpha / (alpha + beta)
        self.variance = alpha * beta / ((alpha + beta)**2 * (alpha + beta + 1))
        super
      end

      private

      def gsl_f
        gsl_cdf.beta_P(x, alpha, beta)
      end

      def gsl_f_inv
        gsl_cdf.beta_Pinv(f_x, alpha, beta)
      end

      def gsl_g_inv
        gsl_cdf.beta_Qinv(g_x, alpha, beta)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
