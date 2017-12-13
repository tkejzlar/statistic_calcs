# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class GumbelMinimum < Continuous
        # r -> V.A.
        attr_accessor :degrees_of_freedom, :x
        attr_alias :v, :degrees_of_freedom
        attr_alias :mu, :degrees_of_freedom

        def calc!
          # self.mean = xxxx
          # self.variance = yyyyy
          super
        end

        private

        def gsl_p
          gsl_ran.XXXXXXX_pdf
        end

        def gsl_f
          gsl_cdf.XXXXXXX_P
        end

        def gsl_g
          gsl_cdf.XXXXXXX_Q
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
