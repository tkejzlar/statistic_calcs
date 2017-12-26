# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class LogNormal < Continuous
        # x -> V.A.
        attr_accessor :zeta, :sigma, :x

        def calc!
          self.zeta = zeta.to_f
          self.sigma = sigma.to_f
          self.mean = GSL::M_E**(zeta + (sigma**2 / 2))
          self.variance = (GSL::M_E**(sigma**2) - 1) * GSL::M_E**(2 * zeta + (sigma**2))
          super
        end

        private

        def gsl_f
          gsl_cdf.lognormal_P(x, zeta, sigma)
        end

        def gsl_g
          1 - gsl_f
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
