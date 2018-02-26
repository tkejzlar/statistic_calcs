# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/base'
require 'statistic_calcs/helpers/required_validations'

module StatisticCalcs
  module HypothesisTest
    # Test a mean for known sigma
    class Mean < Base
      include StatisticCalcs::Helpers::RequiredValidations

      attr_accessor :sample_mean, :mean_to_test, :mean_to_test1

      attr_alias :x0, :mean_to_test

      def calc!
        super
        calc_case1 if case1?
        calc_case2 if case2?
        calc_case3 if case3?
        self
      end

      def validate!
        super
        raise StandardError, 'Case type is required.CASE_1 / CASE_2 / CASE_3' unless self.case
        raise StandardError, 'population_size should greater than sample_size' if population_size && sample_size > population_size
      end

      private

      def calc_case1
        self.h0 = "mean <= x0 (#{mean_to_test})"
        self.h1 = "mean > x1 (#{mean_to_test1})"
        self.critical_fractil = mean_to_test + distribution(1 - alpha) * multiplier_factor
        self.reject = sample_mean > critical_fractil
        self.reject_condition = "X > Xc -> reject H0. `#{sample_mean} > #{critical_fractil.round(2)}` -> #{reject}"
      end

      def calc_case2
        self.h0 = "mean >= x0 (#{mean_to_test})"
        self.h1 = "mean < x1 (#{mean_to_test1})"
        self.critical_fractil = mean_to_test - distribution(1 - alpha) * multiplier_factor
        self.reject = sample_mean < critical_fractil
        self.reject_condition = "X < Xc -> reject H0. `#{sample_mean} < #{critical_fractil.round(2)}` -> #{reject}"
      end

      def calc_case3
        self.h0 = "mean = x0 (#{mean_to_test})"
        self.h1 = "mean >< x1 (#{mean_to_test1})"
        self.lower_critical_fractil = mean_to_test - distribution(1 - alpha / 2) * multiplier_factor
        self.upper_critical_fractil = mean_to_test + distribution(1 - alpha / 2) * multiplier_factor
        self.reject = sample_mean > lower_critical_fractil || sample_mean < lower_critical_fractil
        self.reject_condition = "X > Xc1 or X < Xc2-> reject H0. `#{sample_mean} > #{lower_critical_fractil.round(2)} or #{sample_mean} < #{upper_critical_fractil.round(2)}` -> #{reject}"
      end

      def multiplier_factor
        sigma / sample_size**0.5
      end
    end
  end
end
