# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'
require 'statistic_calcs/helpers/math.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class GumbelMaximum < Continuous
        # x -> V.A.
        # beta (scale)
        # thita (corrimiento y moda)
        attr_accessor :thita, :beta, :x

        def calc!
          self.mean = thita + beta.to_f * Helpers::Math.euler
          self.variance = Helpers::Math.pi**2 * beta**2 / 6
          super
        end

        private

        def gsl_f
          # return 0
          # gsl_cdf.gumbel1_P(x, mean, beta)
        end

        def gsl_f_inv
          gsl_cdf.gumbel1_Pinv(f_x, mean, beta)
        end

        def gsl_g_inv
          gsl_cdf.gumbel1_Qinv(g_x, mean, beta)
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
