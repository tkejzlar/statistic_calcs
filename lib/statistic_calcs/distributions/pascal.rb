# frozen_string_literal: true

require 'statistic_calcs/distributions/discrete'

module StatisticCalcs
  module Distributions
    class Pascal < Discrete
      attr_accessor :probability_of_success, :number_trials, :number_successes

      attr_alias :p, :probability_of_success
      # n -> V.A.
      attr_alias :n, :number_trials
      attr_alias :r, :number_successes

      def calc!
        calculate_p! unless p
        calculate_n! unless n
        self.mean = r / p
        self.variance = (r * (1 - p)) / p**2
        # self.skewness = (1 - 2 * p) / variance
        # self.kurtosis = 3 + ((1 - 6 * p * (1 - p)) / variance)
        # self.coefficient_variation = variance / mean
        super
      end

      private

      def calculate_p!
        raise 'Not implemented!'
        # Double fisherX = new FisherSnedecorDistributionCalc().numeratorDegreesOfFreedom((double) 2 * r + 2)
        # denominatorDegreesOfFreedom((double) 2 * n - 2 * r).f(1 - f).calculatePx().x();
        # p = 1 / (1 + (((double) (n - r) / ((r + 1) * fisherX))));
      end

      def calculate_n!
        if f_x
          self.r = inverse_f
        elsif g_x
          self.r = inverse_g
        else
          raise 'N can\'t be calculated without f or g'
        end
      end

      def gsl_p
        gsl_ran.pascal_pdf(n - r, p, r)
      end

      def gsl_f
        gsl_cdf.pascal_P(n - r, p, r)
      end

      def gsl_g
        gsl_cdf.pascal_Q(n - r - 1, p, r)
      end

      # TODO: use binary search to find faster
      def inverse_f
        return 0 if f_x.zero?
        temp_value = i = 0
        while temp_value <= f_x && i < n
          temp_value = gsl_cdf.pascal_P(i, p, n)
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
          temp_value = gsl_cdf.pascal_Q(i - 1, p, n)
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
