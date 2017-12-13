# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/continuous.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class Normal < Continuous
        # x -> V.A.
        # -inf < mean < inf
        # sigma > 0
        # -inf < x < inf
        attr_accessor :x

        def calc!
          super
        end

        private

        def gsl_f
          gsl_cdf.ugaussian_P(x - mean, standard_deviation)
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
