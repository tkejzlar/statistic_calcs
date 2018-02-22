# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/base.rb'
require 'statistic_calcs/descriptive/distributions/normal.rb'

module StatisticCalcs
  module HypothesisTest
    # Test a mean for known sigma
    class KnownSigmaMean < Base
      attr_accessor :population_size, :population_standard_deviation,
                    :sample_size, :sample_mean, :mean_to_test, :mean_to_test1

      attr_alias :standard_deviation, :population_standard_deviation
      attr_alias :sigma, :population_standard_deviation
      attr_alias :n, :population_size
      attr_alias :x0, :mean_to_test

      def calc!
        calc_case1 if case1?
        calc_case2 if case2?
        calc_case3 if case3?
        self
      end

      def init!
        super
        if test_power
          self.beta = 1 - test_power
        else
          self.beta ||= 0.05
          self.test_power = 1 - beta
        end
      end

      def validate!
        super
        raise StandardError, 'Case type is required.CASE_1 / CASE_2 / CASE_3' unless self.case
        raise StandardError, 'beta should be between 0 and 1' unless beta.between?(0, 1)
        raise StandardError, 'test_power should be between 0 and 1' unless test_power.between?(0, 1)
        raise StandardError, 'population_size should greater than sample_size' if population_size && sample_size > population_size
      end

      private

      def case1?
        self.case == 1
      end

      def calc_case1
        self.h0 = "mean <= x0 (#{mean_to_test})"
        self.h1 = "mean > x1 (#{mean_to_test1})"
        self.critical_fractil = mean_to_test + normal_dist(1 - alpha) * multiplier_factor
        self.reject = sample_mean > critical_fractil
        self.reject_condition = "X > Xc -> reject H0. `#{sample_mean} > #{critical_fractil.round(2)}` -> #{reject}"
      end

      def case2?
        self.case == 2
      end

      def calc_case2
        self.h0 = "mean >= x0 (#{mean_to_test})"
        self.h1 = "mean < x1 (#{mean_to_test1})"
        self.critical_fractil = mean_to_test - normal_dist(1 - alpha) * multiplier_factor
        self.reject = sample_mean < critical_fractil
        self.reject_condition = "X < Xc -> reject H0. `#{sample_mean} < #{critical_fractil.round(2)}` -> #{reject}"
      end

      def case3?
        self.case == 3
      end

      def calc_case3
        self.h0 = "mean = x0 (#{mean_to_test})"
        self.h1 = "mean >< x1 (#{mean_to_test1})"
        self.lower_critical_fractil = mean_to_test - normal_dist(1 - alpha / 2) * multiplier_factor
        self.upper_critical_fractil = mean_to_test + normal_dist(1 - alpha / 2) * multiplier_factor
        self.reject = sample_mean > lower_critical_fractil || sample_mean < lower_critical_fractil
        self.reject_condition = "Xc1 < X < Xc2-> reject H0. `#{lower_critical_fractil.round(2)} < #{sample_mean} < #{upper_critical_fractil.round(2)}` -> #{reject}"
      end

      def multiplier_factor
        sigma / sample_size**0.5
      end

      def normal_dist(f_x)
        StatisticCalcs::Descriptive::Distributions::Normal.new(f_x: f_x).calc!.x
      end
    end
  end
end
