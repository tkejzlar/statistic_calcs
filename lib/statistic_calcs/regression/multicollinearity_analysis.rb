# frozen_string_literal: true

require 'matrix'

module StatisticCalcs
  module Regression
    # TODO: refactor module
    # rubocop:disable Metrics/ModuleLength
    module MulticollinearityAnalysis
      def possible_scenarios_indexes
        possible_scenarios.map do |x_keys|
          x_keys.map { |val| val.delete('x') }.map { |val| val.to_i - 1 }
        end
      end

      def possible_scenarios_keys
        @possible_scenarios_keys ||= possible_scenarios.map(&:join)
      end

      def possible_scenarios
        @possible_scenarios ||= (1..parameters_count).flat_map { |size| parameters_list.combination(size).to_a }
      end

      def possible_scenarios_amount
        2**parameters_count - 1
      end

      def parameters_list
        @parameters_list ||= (1..parameters_count).to_a.flat_map { |i| "x#{i}" }
      end

      def x_possible_matrixes
        @x_possible_matrixes ||= begin
          one_values = Array.new(n) { 1 }
          possible_scenarios.each_index.map do |index|
            indexes = possible_scenarios_indexes[index]
            x_values_temp = x_values.values_at(*indexes)
            vectors = [y_values, one_values, *x_values_temp]
            Matrix.columns(vectors)
          end
        end
      end

      def x_possible_matrixes_temp1
        @x_possible_matrixes_temp1 ||= begin
          x_possible_matrixes.each_index.map do |index|
            reduced_matrix = x_possible_reduced_matrixes[index]
            (reduced_matrix.transpose * reduced_matrix).inverse
          end
        end
      end

      def x_possible_values_vectors_temp2
        @x_possible_values_vectors_temp2 ||= begin
          parameters_list.each_index.map do |index|
            list = x_values[index]
            mean ||= list.inject(0.0) { |sum, el| sum + el } / n
            sum_of_squares_of_deviations_of_data_points_from_mean = sum_of_squares_of_deviations_of_data_points_from_mean(list, mean)
            list.map do |row|
              (row - mean) / sum_of_squares_of_deviations_of_data_points_from_mean**0.5
            end
          end
        end
      end

      def x_possible_reduced_matrixes
        @x_possible_reduced_matrixes ||= begin
          x_possible_matrixes.map do |matrix|
            Matrix.columns(matrix.to_a.transpose[1..matrix.column_count - 1])
          end
        end
      end

      # rubocop:disable Metrics/MethodLength
      def multicollinearity_analysis
        # rubocop:disable Metrics/BlockLength
        list = x_possible_matrixes_temp1.each_with_index.map do |temp1_matrix, index|
          reduced_matrix = x_possible_reduced_matrixes[index]
          reduced_matrix_transposed = reduced_matrix.transpose

          i_list = reduced_matrix.row_vectors.map do |row_vector|
            row_matrix = Matrix.rows([row_vector])
            (row_matrix * (temp1_matrix * row_matrix.transpose))[0, 0]
          end
          j_list = (y_matrix - reduced_matrix * (temp1_matrix * reduced_matrix_transposed) * y_matrix).to_a.flatten

          k_list = i_list.each_with_index.map do |i, i_index|
            j_list[i_index].abs.to_f / (1 - i)
          end

          j_sum_of_squares_of_deviations_of_data_points_from_mean = sum_of_squares_of_deviations_of_data_points_from_mean(j_list)

          delta_sum = 0
          # PRESS
          prediction_sum_square = 0
          r_square = 1 - j_sum_of_squares_of_deviations_of_data_points_from_mean / y_values_sum_of_squares_of_deviations_of_data_points_from_mean
          s_square = j_sum_of_squares_of_deviations_of_data_points_from_mean / (n - reduced_matrix.column_count)

          # for 1 variable doesn't make sense calculate the det
          det = reduced_matrix.column_count == 2 ? 1 : calc_det(possible_scenarios_indexes[index])

          k_list.each do |k|
            delta_sum += k
            prediction_sum_square += k**2
          end

          {
            name: possible_scenarios_keys[index],
            indexes: possible_scenarios_indexes[index],
            delta_sum: delta_sum,
            prediction_sum_square: prediction_sum_square,
            r_square: r_square,
            s_square: s_square,
            det: det,
            p: reduced_matrix.column_count
          }
        end
        list.map do |value|
          p = value[:p]
          value[:c_p] = p + (value[:s_square] / list.last[:s_square] - 1) * (n - p)
          value
        end
      end
      # rubocop:enable Metrics/BlockLength
      # rubocop:enable Metrics/MethodLength

      def calc_det(indexes)
        vectors = indexes.map do |index|
          x_possible_values_vectors_temp2[index]
        end
        matrix = Matrix.columns(vectors)
        (matrix.transpose * matrix).det
      end

      # DEVSQ(list)
      def sum_of_squares_of_deviations_of_data_points_from_mean(list, mean = nil)
        mean ||= list.inject(0.0) { |sum, el| sum + el } / n
        list.map { |j| (j - mean)**2 }.inject(:+)
      end

      def y_values_sum_of_squares_of_deviations_of_data_points_from_mean
        @y_values_sum_of_squares_of_deviations_of_data_points_from_mean ||=
          sum_of_squares_of_deviations_of_data_points_from_mean(y_values, y_values_mean)
      end
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
