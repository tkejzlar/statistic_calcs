# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class ChiSquare < Continuous
        # x > 0 -> V.A.
        # v > 0
        attr_accessor :degrees_of_freedom, :x
        attr_alias :v, :degrees_of_freedom
        attr_alias :nu, :degrees_of_freedom

        def calc!
          self.mean = nu
          self.variance = 2 * nu
          super
        end

        private

        def gsl_f
          gsl_cdf.chisq_P(x, v)
        end

        def gsl_f_inv
          gsl_cdf.chisq_Pinv(f_x, v)
        end

        def gsl_g_inv
          gsl_cdf.chisq_Qinv(g_x, v)
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
