# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/discrete.rb'
require 'statistic_calcs/descriptive/distributions/fisher_snedecor.rb'
require 'pry'
module StatisticCalcs
  module Descriptive
    module Distributions
      # Binomial distribution with parameters number_trials (n) and probability_of_success (p)
      # is the discrete probability distribution of the number_successes (r) in a sequence 
      # of number_trials independent experiments
      # ref: https://en.wikipedia.org/wiki/Binomial_distribution
      #
      # This class allow to calculate
      #   P (x < X) => f_x
      #   P (x = X) => p_x
      #   P (x > X) => g_x
      #   the inverse fractil (number_successes)
      #   number_trials (n) or probability_of_success (p)
      #
      class Binomial < Discrete
        attr_accessor :probability_of_success, :number_trials, :number_successes

        attr_alias :p, :probability_of_success
        attr_alias :n, :number_trials
        attr_alias :r, :number_successes

        def calc!
          calculate_p! unless p
          calculate_n! unless n
          calculate_r! unless r
          self.mean = n * p
          self.median = mean.round
          self.variance = n * p * (1 - p)
          self.skewness = (1 - 2 * p) / variance
          self.kurtosis = 3 + ((1 - 6 * p * (1 - p)) / variance)
          self.coefficient_variation = variance / mean
          super
        end

        private

        def calculate_p!
          d1 = 2 * r + 2
          d2 = 2 * n - 2 * r
          f_fs = g_x || 1 - f_x
          fisher = FisherSnedecor.new(d1: d1, d2: d2, f_x: f_fs).calc!
          self.p = 1.0 / (1 + (((n - r) / ((r + 1) * fisher.x))))
        end

        def calculate_n!
          self.variance ||= standard_deviation**2 if standard_deviation&.positive?
          self.n = mean ? (mean / p).round : (variance / (p * (1 - p))).round
        end

        def calculate_r!
          if f_x
            self.r = inverse_f
          elsif g_x
            self.r = inverse_g
          else
            raise 'R can\'t be calculated without f or g'
          end
        end

        def gsl_p
          gsl_ran.binomial_pdf(r, p, n)
        end

        def gsl_f
          gsl_cdf.binomial_P(r, p, n)
        end

        def gsl_g
          gsl_cdf.binomial_Q(r - 1, p, n)
        end

        # TODO: use binary search to find faster
        def inverse_f
          return 0 if f_x.zero?
          temp_value = i = 0
          while temp_value <= f_x && i < n
            temp_value = gsl_cdf.binomial_P(i, p, n)
            next if temp_value >= f_x
            i += 1
          end
          i.zero? ? 0 : i - 1
        end

        def inverse_g
          return n if g_x == 1
          temp_value = 0
          i = n
          while temp_value <= g_x && i.positive?
            temp_value = gsl_cdf.binomial_Q(i - 1, p, n)
            next if temp_value >= g_x
            i -= 1
          end
          i
        end

        def validate!
          raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
        end
      end
    end
  end
end
