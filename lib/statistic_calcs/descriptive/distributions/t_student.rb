# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class TStudent < Continuous
        # v > 0
        # x -> V.A.
        # -inf < x < inf
        attr_accessor :degrees_of_freedom, :x
        attr_alias :v, :degrees_of_freedom
        attr_alias :nu, :degrees_of_freedom

        def calc!
          self.v = v.to_f
          self.mean = 0.0
          if v > 2
            self.variance = v / (v - 2)
          else
            self.variance = Float::INFINITY
            self.standard_deviation = variance
          end
          super
        end

        private

        def gsl_f
          gsl_cdf.tdist_P(x, nu)
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
