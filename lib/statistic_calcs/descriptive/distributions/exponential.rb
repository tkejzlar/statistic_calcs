# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class Exponential < Continuous
        # x > 0 -> V.A.
        # lambda > 0
        attr_accessor :lambda, :x

        def calc!
          self.mean = 1.0 / lambda
          self.variance = 1.0 / lambda**2
          super
        end

        private

        def gsl_f
          gsl_cdf.exponential_P(x, mean)
        end

        def gsl_f_inv
          gsl_cdf.exponential_Pinv(f_x, mean)
        end

        def gsl_g_inv
          gsl_cdf.exponential_Qinv(g_x, mean)
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
