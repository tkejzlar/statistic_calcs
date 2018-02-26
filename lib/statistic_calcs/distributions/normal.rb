# frozen_string_literal: true

require 'statistic_calcs/distributions/continuous'

module StatisticCalcs
  module Distributions
    class Normal < Continuous
      # x -> V.A.
      # -inf < mean < inf
      # sigma > 0
      # -inf < x < inf
      attr_accessor :x

      def calc!
        self.mean ||= 0.0
        self.standard_deviation ||= 1.0
        super
      end

      private

      def gsl_f
        gsl_cdf.ugaussian_P(x - mean, standard_deviation)
      end

      def gsl_f_inv
        gsl_cdf.ugaussian_Pinv(f_x, standard_deviation) + mean
      end

      def gsl_g_inv
        gsl_cdf.ugaussian_Qinv(g_x, standard_deviation) + mean
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
