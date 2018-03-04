# frozen_string_literal: true

require 'statistic_calcs/distributions/continuous'

module StatisticCalcs
  module Distributions
    class GumbelMinimum < Continuous
      # x -> V.A.
      # beta (scale)
      # thita (corrimiento y moda)
      attr_accessor :thita, :beta, :x

      attr_alias :location, :thita
      attr_alias :scale, :beta

      def calc!
        self.mean = thita + beta.to_f * Helpers::Math.euler
        self.variance = Helpers::Math.pi**2 * beta**2 / 6
        super
      end

      private

      def gsl_f
        # a = ???
        # b = ???
        # gsl_cdf.gumbel2_P(x, a, b)
        # 1-EXP(-EXP(+((C176-$N$194)/$N$195)))
        1 - Helpers::Math.e**(-Helpers::Math.e**((x - thita).to_f / beta))
      end

      def gsl_f_inv
        gsl_cdf.gumbel2_Pinv(f_x, mean, beta)
      end

      def gsl_g_inv
        gsl_cdf.gumbel2_Qinv(g_x, mean, beta)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
