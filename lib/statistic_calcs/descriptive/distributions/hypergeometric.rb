# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/discrete.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class Hypergeometric < Discrete
        # n - x <= N - total_number_successes
        # x <= total_number_successes
        # 0, 1, .., n
        # number_successes -> V.A.
        attr_accessor :sample_size, :number_successes,
                      :population_size, :total_number_successes

        # total_number_successes = R
        # population_size = N
        attr_alias :r, :number_successes
        attr_alias :x, :number_successes
        attr_alias :n, :sample_size

        def calc!
          self.mean = n * total_number_successes.to_f / population_size
          # self.variance = calc_variance
          super
        end

        private

        def calculate_p!
          raise 'Not implemented!'
        end

        def gsl_p
          # k = x
          # n_1 => M => total_number_successes
          # n_2 => N - M => population_size - total_number_successes
          # t = n
          gsl_ran.hypergeometric_pdf(x, total_number_successes, population_size - total_number_successes, n)
        end

        def gsl_f
          gsl_cdf.hypergeometric_P(x, total_number_successes, population_size - total_number_successes, n)
        end

        def gsl_g
          gsl_cdf.hypergeometric_Q(x - 1, total_number_successes, population_size - total_number_successes, n)
        end

        def calc_variance
          mean *
            (1.0 - total_number_successes / population_size) *
            ((population_size.to_f - n) / (population_size - 1))
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
