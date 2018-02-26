# frozen_string_literal: true

require 'statistic_calcs//distributions/discrete'

module StatisticCalcs
  module Distributions
    class Poisson < Discrete
      # r -> V.A.
      attr_accessor :frequency, :time_period, :number_successes
      attr_alias :lambda, :frequency
      attr_alias :r, :number_successes

      def calc!
        self.time_period ||= 1
        self.mean = frequency * time_period
        self.variance = mean
        super
      end

      private

      def gsl_p
        gsl_ran.poisson_pdf(r, mean)
      end

      def gsl_f
        gsl_cdf.poisson_P(r, mean)
      end

      def gsl_g
        gsl_cdf.poisson_Q(r - 1, mean)
      end

      def validate!
        raise 'f_x should be between 0 and 1' if f_x.negative? || f_x > 1
      end
    end
  end
end
