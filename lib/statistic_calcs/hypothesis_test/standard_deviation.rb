# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/base'
require 'statistic_calcs/helpers/required_validations'
require 'statistic_calcs/distributions/chi_square'

module StatisticCalcs
  module HypothesisTest
    class StandardDeviation < Base
      include StatisticCalcs::Helpers::RequiredValidations

      attr_accessor :sample_standard_deviation, :standard_deviation_to_test, :standard_deviation_to_test1

      attr_alias :s0, :standard_deviation_to_test

      required %i[sample_standard_deviation sample_size standard_deviation_to_test case]

      def calc!
        super
        calc_case1 if case1?
        calc_case2 if case2?
        self
      end

      def validate!
        super
        raise StandardError, 'Case type is required.CASE_1 / CASE_2' unless self.case == Cases::CASE_1 || self.case == Cases::CASE_2
      end

      private

      def calc_case1
        self.h0 = "sigma <= s0 (#{standard_deviation_to_test})"
        self.h1 = "sigma > s1 (#{standard_deviation_to_test1})"
        self.critical_fractil = (chi_square_dist(confidence_level) * multiplier_factor)**0.5
        self.reject = sample_standard_deviation > critical_fractil
        self.reject_condition = "S > Sc -> reject H0. `#{sample_standard_deviation} > #{critical_fractil.round(2)}` -> #{reject}"
      end

      def calc_case2
        self.h0 = "sigma >= s0 (#{standard_deviation_to_test})"
        self.h1 = "sigma < s1 (#{standard_deviation_to_test1})"
        self.critical_fractil = (chi_square_dist(alpha) * multiplier_factor)**0.5
        self.reject = sample_standard_deviation < critical_fractil
        self.reject_condition = "S < Sc -> reject H0. `#{sample_standard_deviation} < #{critical_fractil.round(2)}` -> #{reject}"
      end

      def multiplier_factor
        (s0**2).to_f / degrees_of_freedom
      end

      def chi_square_dist(f_x)
        StatisticCalcs::Distributions::ChiSquare.new(f_x: f_x, degrees_of_freedom: degrees_of_freedom).calc!.x
      end
    end
  end
end
