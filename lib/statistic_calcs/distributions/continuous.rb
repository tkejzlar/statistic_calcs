# frozen_string_literal: true

require 'statistic_calcs/distributions/base'

module StatisticCalcs
  module Distributions
    class Continuous < Base
      def calc!
        self.x ||= gsl_f_inv if f_x
        self.x ||= gsl_g_inv if g_x
        self.f_x ||= gsl_f if x
        self.g_x ||= 1 - f_x if x
        super
      end

      def continuous?
        true
      end

      def discrete?
        false
      end

      private

      def gsl_g
        1 - gsl_f
      end
    end
  end
end
