# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes.rb'
require 'statistic_calcs/helpers/array_validations.rb'
require 'statistic_calcs/data_set.rb'

module StatisticCalcs
  module RegressionTheory
    # Estimation of a variable (the dependent variable) from another's variables (the independent variables).
    # This class will calculate the related correlation or degree of relationship between the variables,
    # in which will try to determine how well a linear equation, describes or explains the relationship between them
    # Model: `Y = Beta0 + Beta1 X + E`
    # Estimator: `y = b0 + b1 x`
    # Y: variable to explain
    # X: explains variable, known value (constant)
    # Beta0: intercept
    # Beta1: slope
    # E: disturbance of the environment, error, noise
    class SimpleLinealRegression
      include StatisticCalcs::Helpers::AliasAttributes
      include StatisticCalcs::Helpers::ArrayValidations

      SOCIAL_MIN_R = 0.6
      ECONOMIC_MIN_R = 0.7
      TECH_MIN_R = 0.85

      attr_accessor :dependent_values, :independent_values,
                    :slope, :intercept,
                    :pearson_correlation_coefficient, :covariance, :x_values_variance,
                    :determination_coefficient, :determination_coefficient_adjusted,
                    :n, :x_values_standard_deviation, :degrees_of_freedom,
                    :y_values_sum, :y_values_square_sum, :y_values_mean,
                    :x_values_sum, :x_values_square_sum, :x_values_mean,
                    :xy_values_sum

      attr_alias :y_values, :dependent_values
      attr_alias :x_values, :independent_values
      attr_alias :b0, :intercept
      attr_alias :b1, :slope
      attr_alias :correlation_coefficient, :pearson_correlation_coefficient
      attr_alias :r, :pearson_correlation_coefficient
      attr_alias :r_square, :determination_coefficient
      attr_alias :r_square_adj, :determination_coefficient_adjusted

      attr_alias :variance, :x_values_variance
      attr_alias :standard_deviation, :x_values_standard_deviation

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

      def equation
        # y = b0 + b1 x
        "y = #{b0.round(3)} + #{b1.round(3)} x"
      end

      private

      def init!
        self.n = y_values&.count || 0
        self.degrees_of_freedom = n - 2 # 2 parameters
        self.xy_values_sum = 0
        self.y_values_square_sum = 0
        self.x_values_square_sum = 0
      end

      def validate!
        super(:y_values)
        super(:x_values)
        raise StandardError, 'y_values & x_values should have the same amount of values' unless y_values.count == x_values.count
      end

      def calculate!
        pre_calcs!
        self.b1 = calc_b1
        self.b0 = calc_b0
        self.r = calc_correlation_coefficient
        # R Square of a model increases even if the variables we include are not relevant
        self.r_square = r**2
        # R Squared squared penalizes the inclusion of variables.
        self.r_square_adj = calc_r_adjusted
        self.covariance = (xy_values_sum / n) - (x_values_mean * y_values_mean)
      end

      # rubocop:disable MethodLength
      def pre_calcs!
        StatisticCalcs::DataSet.new(x_values: y_values).analyze!.tap do |result|
          self.y_values_mean = result.mean
          self.y_values_sum = result.sum
        end
        StatisticCalcs::DataSet.new(x_values: x_values).analyze!.tap do |result|
          self.x_values_mean = result.mean
          self.x_values_sum = result.sum
          self.variance = result.variance
          self.standard_deviation = result.standard_deviation
        end
        iteration_calcs
      end
      # rubocop:enable MethodLength

      def iteration_calcs
        y_values.each_with_index do |y, index|
          x = x_values[index]
          self.xy_values_sum += y * x
          self.y_values_square_sum += y**2
          self.x_values_square_sum += x**2
        end
      end

      def calc_b1
        (xy_values_sum - n * y_values_mean * x_values_mean) / (x_values_square_sum - n * x_values_mean**2)
      end

      def calc_b0
        y_values_mean - b1 * x_values_mean
      end

      def calc_correlation_coefficient
        numerator = b0 * y_values_sum + b1 * xy_values_sum - n * y_values_mean**2
        divisor = y_values_square_sum - n * y_values_mean**2
        (numerator / divisor)**0.5
      end

      def calc_r_adjusted
        1 - (((n - 1) / degrees_of_freedom) * (1 - r_square))
      end
    end
  end
end
