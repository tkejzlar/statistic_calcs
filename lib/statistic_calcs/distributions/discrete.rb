# frozen_string_literal: true

require 'statistic_calcs/distributions/base'

module StatisticCalcs
  module Distributions
    # Binomial, Geometric, Hypergeometric, Pascal, Poisson
    class Discrete < Base
      attr_accessor :probability_x

      attr_alias :p_x, :probability_x

      def calc!
        self.p_x = gsl_p
        self.f_x = gsl_f
        self.g_x = gsl_g
        super
      end

      def discrete?
        true
      end

      def continuous?
        false
      end
    end
  end
end
