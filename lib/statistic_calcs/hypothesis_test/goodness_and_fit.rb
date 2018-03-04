# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/base'
require 'statistic_calcs/helpers/required_validations'
require 'statistic_calcs/distributions/chi_square'
require 'statistic_calcs/chi_square_contrast/goodness_and_fit'

module StatisticCalcs
  module HypothesisTest
    class GoodnessAndFit < Base
      include StatisticCalcs::Helpers::RequiredValidations

      attr_accessor :data

      required %i[data]

      def calc!
        super
        data&.calc!
        self.h0 = "Xc^2 <= X^2(1 - alpha, V). #{data.critical_chi_square} <= #{chi_square}"
        self.h1 = 'Xc^2 > X^2'
        self.critical_fractil = data.critical_chi_square
        self.reject = critical_fractil > chi_square
        self.reject_condition = "Xc^2 > X^2 -> reject H0. `#{critical_fractil.round(2)} > #{chi_square.round(2)}` -> #{reject}"
        self
      end

      def validate!
        super
        raise StandardError, '`data` should be a `StatisticCalcs::ChiSquareContrast::GoodnessAndFit` object' unless data.is_a?(StatisticCalcs::ChiSquareContrast::GoodnessAndFit)
      end

      private

      def chi_square
        @chi_square ||= chi_square_dist(1 - alpha)
      end

      def chi_square_dist(f_x)
        StatisticCalcs::Distributions::ChiSquare.new(f_x: f_x, degrees_of_freedom: data.degrees_of_freedom).calc!.x
      end
    end
  end
end
