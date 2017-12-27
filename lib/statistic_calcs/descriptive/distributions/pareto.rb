# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class Pareto < Continuous
        # m > 0 => scale
        # alpha > 0 => shape
        # x > m -> V.A.
        attr_accessor :m, :alpha, :x

        attr_alias :a, :alpha

        def calc!
          self.alpha = alpha.to_f
          self.m = m.to_f
          self.mean = alpha * m / (alpha - 1) if alpha > 1
          self.variance = (alpha * m**2) / ((alpha - 1)**2 * (alpha - 2)) if alpha > 2
          super
        end

        private

        def gsl_f
          gsl_cdf.pareto_P(x, alpha, m)
        end

        def gsl_f_inv
          gsl_cdf.pareto_Pinv(f_x, alpha, m)
        end

        def gsl_g_inv
          gsl_cdf.pareto_Qinv(g_x, alpha, m)
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
