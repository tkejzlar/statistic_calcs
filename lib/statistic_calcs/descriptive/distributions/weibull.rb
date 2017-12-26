# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class Weibull < Continuous
        # x -> V.A.
        # alpha > 0 shape
        # beta > 0 scale (avg. time)
        # x > 0
        attr_accessor :alpha, :beta, :x

        def calc!
          self.alpha = alpha.to_f
          self.beta = beta.to_f

          # https://math.stackexchange.com/questions/1769765/weibull-distribution-from-mean-and-variance-to-shape-and-scale-factor
          fact_temp = factorial(1 + (1.0 / alpha))
          fact_temp2 = factorial(1 + (2.0 / alpha))
          self.mean = beta * fact_temp
          self.variance = beta**2 * (fact_temp2 - fact_temp**2)
          super
        end

        private

        def gsl_f
          gsl_cdf.weibull_P(x, beta, alpha)
        end

        def gsl_g
          1 - gsl_f
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end

        def factorial(value)
          # return factorial_aprox(value) if value.is_a?(Float)
          return GSL::Sf.gamma(value + 1) if value.is_a?(Float)
          GSL::Sf.fact(value)
        end

        # better value with gamma
        # def factorial_aprox(value)
        #   Math.sqrt(GSL::M_PI) * (value / GSL::M_E)**value \
        #     * (((8 * value + 4) * value + 1) * value + 1.0 / 30.0)**(1.0 / 6.0)
        # end
      end
    end
  end
end
