# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes'
require 'statistic_calcs/helpers/array_validations'
require 'statistic_calcs/distributions/normal'
require 'statistic_calcs/distributions/t_student'
require 'statistic_calcs/data_sets/data_set'
require 'statistic_calcs/inference/errorable'
require 'pry'

module StatisticCalcs
  module Regression
    class Base
      include StatisticCalcs::Helpers::AliasAttributes
      include StatisticCalcs::Inference::Errorable
      include StatisticCalcs::Helpers::ArrayValidations

      SOCIAL_MIN_R = 0.6
      ECONOMIC_MIN_R = 0.7
      TECH_MIN_R = 0.85

      # parameters
      attr_accessor :dependent_values, # y values
                    :independent_values # x values

      # math calcs
      attr_accessor :slope, :intercept, # estimation b0 & b1
                    :n, :degrees_of_freedom

      # statistic estimators
      attr_accessor :correlation_coefficient_lower_limit,
                    :correlation_coefficient_upper_limit,
                    :correlation_coefficient_estimator,
                    :covariance,
                    :determination_coefficient_lower_limit,
                    :determination_coefficient_upper_limit,
                    :determination_coefficient_estimator,
                    :determination_coefficient_estimator_adjusted,
                    :model_standard_deviation,
                    :model_variance

      # calcs
      attr_accessor :y_values_mean,
                    :y_values_square_sum,
                    :y_values_sum

      attr_alias :b0, :intercept
      attr_alias :b1, :slope
      attr_alias :x_values, :independent_values
      attr_alias :y_values, :dependent_values

      attr_alias :ro_lower_limit, :correlation_coefficient_lower_limit
      attr_alias :ro_upper_limit, :correlation_coefficient_upper_limit
      attr_alias :r, :correlation_coefficient_estimator

      attr_alias :ro_square_lower_limit, :determination_coefficient_lower_limit
      attr_alias :ro_square_upper_limit, :determination_coefficient_upper_limit
      attr_alias :r_square, :determination_coefficient_estimator
      attr_alias :r_square_adj, :determination_coefficient_estimator_adjusted

      attr_alias :standard_deviation, :model_standard_deviation
      attr_alias :variance, :model_variance

      def calc!
        init!
        validate!
        calculate!
      end

      def valid_correlation_for_social_problems?
        r.abs >= SOCIAL_MIN_R
      end

      def valid_correlation_for_economic_problems?
        r.abs >= ECONOMIC_MIN_R
      end

      def valid_correlation_for_tech_problems?
        r.abs >= TECH_MIN_R
      end

      private

      def init!
        super
        self.n = y_values&.count || 0
      end

      def calculate!; end

      def z
        normal_dist.calc!.x
      end

      def t
        t_student_dist.calc!.x
      end

      def normal_dist
        StatisticCalcs::Distributions::Normal.new(f_x: 1.0 - alpha / 2)
      end

      def t_student_dist
        StatisticCalcs::Distributions::TStudent.new(f_x: 1.0 - alpha / 2, degrees_of_freedom: degrees_of_freedom)
      end
    end
  end
end
