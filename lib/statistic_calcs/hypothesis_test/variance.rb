# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/base'
require 'statistic_calcs/helpers/required_validations'
require 'statistic_calcs/distributions/chi_square'

module StatisticCalcs
  module HypothesisTest
    class Variance < Base
      include StatisticCalcs::Helpers::RequiredValidations

      attr_accessor :sample_variance, :variance_to_test, :variance_to_test1

      required %i[sample_variance sample_size variance_to_test case]

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
        self.h0 = "sigma^2 <= s0 (#{variance_to_test})"
        self.h1 = "sigma^2 > s1 (#{variance_to_test1})"
        self.critical_fractil = chi_square_dist(confidence_level) * multiplier_factor
        self.reject = sample_variance > critical_fractil
        self.reject_condition = "S^2 > S^2c -> reject H0. `#{sample_variance} > #{critical_fractil.round(2)}` -> #{reject}"
      end

      def calc_case2
        self.h0 = "sigma^2 >= s0 (#{variance_to_test})"
        self.h1 = "sigma^2 < s1 (#{variance_to_test1})"
        self.critical_fractil = chi_square_dist(alpha) * multiplier_factor
        self.reject = sample_variance < critical_fractil
        self.reject_condition = "S^2 < S^2c -> reject H0. `#{sample_variance} < #{critical_fractil.round(2)}` -> #{reject}"
      end

      def multiplier_factor
        variance_to_test.to_f / degrees_of_freedom
      end

      def chi_square_dist(f_x)
        StatisticCalcs::Distributions::ChiSquare.new(f_x: f_x, degrees_of_freedom: degrees_of_freedom).calc!.x
      end
    end
  end
end
