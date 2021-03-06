# frozen_string_literal: true

require 'statistic_calcs/regression/base'

module StatisticCalcs
  module Regression
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
    class SimpleLinearRegression < Base
      attr_accessor :x_values_mean,
                    :x_values_square_sum,
                    :x_values_standard_deviation,
                    :x_values_sum,
                    :x_values_variance,
                    :xy_values_sum,
                    :b1_standard_deviation

      def equation
        # y = b0 + b1 x
        "y = #{b0.round(3)} + #{b1.round(3)} x"
      end

      def ro_boundaries
        # P(A < ro < B) = 1 - alpha
        "P(#{ro_lower_limit.round(3)} < ro < #{ro_upper_limit.round(3)}) = #{confidence_level * 100}%"
      end

      def ro_square_boundaries
        # P(A < ro < B) = 1 - alpha
        "P(#{ro_square_lower_limit.round(3)} < ro < #{ro_square_upper_limit.round(3)}) = #{confidence_level * 100}%"
      end

      # rubocop:disable MethodLength
      def y0_estimation(x0)
        y0 = b0 + b1 * x0
        barycentre_distance = ((1.0 / n) + (x0 - x_values_mean)**2 / (x_values_square_sum - n * x_values_mean**2))**0.5
        error = t * standard_deviation * barycentre_distance
        lower_limit = y0 - error
        upper_limit = y0 + error
        {
          y0: y0,
          error: error,
          lower_limit: lower_limit,
          upper_limit: upper_limit,
          y0_boundaries: "P(#{lower_limit.round(3)} < y0 < #{upper_limit.round(3)}) = #{confidence_level * 100}%"
        }
      end
      # rubocop:enable MethodLength

      private

      def init!
        super
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

      # rubocop:disable MethodLength
      def calculate!
        pre_calcs!
        self.b1 = calc_b1
        self.b0 = calc_b0
        self.r = calc_correlation_coefficient_estimator
        # R Square of a model increases even if the variables we include are not relevant
        self.r_square = r**2
        # R Squared squared penalizes the inclusion of variables.
        self.r_square_adj = calc_r_adjusted
        self.covariance = (xy_values_sum / n) - (x_values_mean * y_values_mean)
        self.model_standard_deviation = calc_model_standard_deviation
        self.model_variance = model_standard_deviation**2
        self.b1_standard_deviation = calc_b1_standard_deviation
        calc_correlation_coefficient_limits!
      end

      def pre_calcs!
        StatisticCalcs::DataSets::DataSet.new(x_values: y_values).calc!.tap do |result|
          self.y_values_mean = result.mean
          self.y_values_sum = result.sum
        end
        StatisticCalcs::DataSets::DataSet.new(x_values: x_values).calc!.tap do |result|
          self.x_values_mean = result.mean
          self.x_values_sum = result.sum
          self.x_values_variance = result.variance
          self.x_values_standard_deviation = result.standard_deviation
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

      def calc_correlation_coefficient_estimator
        numerator = b0 * y_values_sum + b1 * xy_values_sum - n * y_values_mean**2
        divisor = y_values_square_sum - n * y_values_mean**2
        (numerator / divisor)**0.5
      end

      def calc_b1_standard_deviation
        model_standard_deviation / (x_values_square_sum - n * x_values_mean**2)**0.5
      end

      def calc_r_adjusted
        1 - (((n - 1) / degrees_of_freedom) * (1 - r_square))
      end

      def calc_model_standard_deviation
        ((y_values_square_sum - b0 * y_values_sum - b1 * xy_values_sum) / degrees_of_freedom)**0.5
      end

      def correlation_coefficient_error
        z * (1.0 / (n - 3))**0.5
      end

      def calc_correlation_coefficient_limits!
        base_value = 0.5 * Math.log((1 + r) / (1 - r))
        z_min = base_value - correlation_coefficient_error
        z_max = base_value + correlation_coefficient_error
        self.ro_lower_limit = (Math.exp(2 * z_min) - 1) / (Math.exp(2 * z_min) + 1)
        self.ro_upper_limit = (Math.exp(2 * z_max) - 1) / (Math.exp(2 * z_max) + 1)
        self.ro_square_lower_limit = ro_lower_limit**2
        self.ro_square_upper_limit = ro_upper_limit**2
      end
    end
  end
end
