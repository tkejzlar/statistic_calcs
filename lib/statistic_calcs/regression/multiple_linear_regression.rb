# frozen_string_literal: true

require 'statistic_calcs/regression/base'
require 'statistic_calcs/regression/matrix_calculations'
require 'statistic_calcs/regression/matrix_pearson_coefficient_calculation'
require 'statistic_calcs/regression/multicollinearity_analysis'
require 'matrix'

module StatisticCalcs
  module Regression
    # Estimation of a variable (the dependent variable) from another's variables (the independent variables).
    # This class will calculate the related correlation or degree of relationship between the variables,
    # in which will try to determine how well a linear equation, describes or explains the relationship between them
    # Model: `Y = Beta0 + Beta1 X1 + Beta2 x2 + ... + BetaN xN + E`
    # Estimator: `y = b0 + b1 x1 + b2 x2 + ... + bN xN`
    # Y: variable to explain
    # X: explains variable, known value (constant)
    # Beta0: intercept
    # BetaN: slopes
    # E: disturbance of the environment, error, noise
    class MultipleLinearRegression < Base
      include StatisticCalcs::Regression::MatrixCalculation
      include StatisticCalcs::Regression::MatrixPearsonCoefficientCalculation
      include StatisticCalcs::Regression::MulticollinearityAnalysis

      # parameters
      attr_accessor :independent_values, # x_i matrix values [[1,2,3],[2,3,4]]
                    :parameters_count,
                    :x_values_mean_matrix,
                    :x_values_square_sum_matrix,
                    :x_values_standard_deviation_matrix,
                    :x_values_sum_matrix,
                    :x_values_skew_matrix,
                    :x_values_kurtosis_matrix,
                    :x_values_variance_matrix,
                    :x_values_covariance_matrix,
                    :y_values_variance

      attr_alias :x_values, :independent_values
      attr_alias :p, :parameters_count

      # min_standard_deviation max_standard_deviation
      # min_skew max_skew
      # min_kurtosis max_kurtosis
      %w[standard_deviation skew kurtosis].each do |property|
        %w[max min].each do |type|
          define_method("#{type}_#{property}") do
            i = send("x_values_#{property}_matrix").each_with_index.send(type)[1] + 1
            "x#{i}"
          end
        end
      end

      def y_standard_error
        @y_standard_error ||= (residual_sum_squares / (n - p - 1))**0.5
      end
      alias standard_deviation y_standard_error

      def y_standard_error_square
        @y_standard_error_square ||= y_standard_error**2
      end
      alias variance y_standard_error_square

      def f_observed
        sum_squares / residual_sum_squares
      end

      def r_square
        @r_square ||= 1 - residual_sum_squares / total_sum_squares
      end

      def r
        r_square**0.5
      end

      def sum_squares
        @sum_squares ||= begin
          y_values.inject(0) { |acum, y| acum + (y - y_values_mean)**2 } - residual_sum_squares
        end
      end

      def residual_sum_squares
        @residual_sum_squares ||= begin
          tmp = x_matrix_transposed_by_x_matrix_inv_by_x_matrix_transposed_by_y_matrix.transpose * x_matrix_transposed_by_y_matrix
          (y_matrix_transposed_by_y_matrix - tmp).to_a[0][0].to_f
        end
      end

      def total_sum_squares
        sum_squares + residual_sum_squares
      end

      def b_values
        @b_values ||= begin
          x_matrix_transposed_by_x_matrix_inv_by_x_matrix_transposed_by_y_matrix
            .to_a
            .flatten
            .each_with_index
            .map { |value, i| ["b#{i}".to_sym, value.to_f] }
            .to_h
        end
      end

      def b_values_standard_deviations
        @b_values_standard_deviations ||= begin
          Array.new(size).each_with_index.map do |_, i|
            ["b#{i}".to_sym, (y_standard_error**2 * x_matrix_transposed_by_x_matrix_inv[i, i])**0.5]
          end.to_h
        end
      end
      alias b_values_standard_errors b_values_standard_deviations

      # y = b0 + b1 x1 + .. + bn xn
      def equation
        @equation ||= begin
          val = "y = #{b_values[:b0].round(3)} + "
          val += b_values
                 .drop(1)
                 .each_with_index.map { |k, i| "#{k[1].round(4)} x#{i + 1}" }
                 .join(' + ')

          val.gsub!(' + -', ' - ')
          val
        end
      end

      def size
        parameters_count + 1
      end

      private

      def init!
        super
        self.n = y_values&.count || 0
        self.parameters_count = x_values.count
        self.degrees_of_freedom = n - parameters_count - 1
        init_arrays
        calculate_y_values
        calculate_x_values
      end

      def init_arrays
        self.x_values_mean_matrix = Array.new(parameters_count)
        self.x_values_sum_matrix = Array.new(parameters_count)
        self.x_values_variance_matrix = Array.new(parameters_count)
        self.x_values_standard_deviation_matrix = Array.new(parameters_count)
        self.x_values_skew_matrix = Array.new(parameters_count)
        self.x_values_kurtosis_matrix = Array.new(parameters_count)
      end

      def calculate_y_values
        StatisticCalcs::DataSets::DataSet.new(x_values: y_values).calc!.tap do |result|
          self.y_values_mean = result.mean
          self.y_values_variance = result.variance
          self.y_values_sum = result.sum
        end
        self.y_values_square_sum = 0
        y_values.each do |y|
          self.y_values_square_sum += y**2
        end
      end

      def calculate_x_values
        x_values.each_with_index do |values, index|
          StatisticCalcs::DataSets::DataSet.new(x_values: values).calc!.tap do |result|
            x_values_mean_matrix[index] = result.mean
            x_values_sum_matrix[index] = result.sum
            x_values_variance_matrix[index] = result.variance
            x_values_standard_deviation_matrix[index] = result.standard_deviation
            x_values_skew_matrix[index] = result.skew
            x_values_kurtosis_matrix[index] = result.kurtosis
          end
        end
      end

      def validate!
        x_values.each do |values|
          raise StandardError, 'y_values & x_values should have the same amount of values' unless y_values.count == values.count
        end
        raise StandardError, 'There aren\'t enough data to make this calculation' unless enough_data?
      end

      def enough_data?
        parameters_count > 1 && n > size
      end

      def calculate!; end
    end
  end
end
