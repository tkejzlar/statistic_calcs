# frozen_string_literal: true

require 'matrix'

module StatisticCalcs
  module Regression
    module MatrixCalculation
      def x_matrix
        @x_matrix ||= begin
          vectors = [Array.new(n) { 1 }].concat(x_values)
          Matrix.columns(vectors)
        end
      end

      def y_matrix
        @y_matrix ||= Matrix.column_vector(y_values)
      end

      def y_matrix_transposed
        @y_matrix_transposed ||= y_matrix.transpose
      end

      def y_matrix_transposed_by_y_matrix
        @y_matrix_transposed_by_y_matrix ||= y_matrix_transposed * y_matrix
      end

      def x_matrix_transposed
        @x_matrix_transposed ||= x_matrix.transpose
      end

      def x_matrix_transposed_by_x_matrix
        @x_matrix_transposed_by_x_matrix ||= x_matrix_transposed * x_matrix
      end

      def x_matrix_transposed_by_x_matrix_inv
        @x_matrix_transposed_by_x_matrix_inv ||= x_matrix_transposed_by_x_matrix.inverse
      end

      def x_matrix_transposed_by_x_matrix_inv_by_x_matrix_transposed_by_y_matrix
        @x_matrix_transposed_by_x_matrix_inv_by_x_matrix_transposed_by_y_matrix ||= x_matrix_transposed_by_x_matrix_inv * x_matrix_transposed_by_y_matrix
      end

      def x_matrix_transposed_by_y_matrix
        @x_matrix_transposed_by_y_matrix ||= (x_matrix_transposed * y_matrix)
      end

      def covariance_matrix
        @covariance_matrix ||= begin
          # Bij = Sum( Xij - X_mean )
          # fill temp matrix for calcs
          y_matrix_temp = y_values.map { |y| y - y_values_mean }
          x_matrix_temp = x_values.each_with_index.map { |list, i| list.map { |x| x - x_values_mean_matrix[i] } }
          vectors = [y_matrix_temp].concat(x_matrix_temp)

          b = Matrix.columns(vectors)
          b_trans = b.transpose
          # cov_matrix = B * B' * 1 / (n - 1)
          b_trans * b / n
        end
      end

      # covariance_matrix[row, col] / covariance_matrix[row, row] * covariance_matrix[col, col]
      def correlation_matrix
        generate_r_matrixes unless @correlation_matrix
        @correlation_matrix
      end

      def r_square_matrix
        generate_r_matrixes unless @r_square_matrix
        @r_square_matrix
      end

      def adj_r_square_matrix
        generate_r_matrixes unless @adj_r_square_matrix
        @adj_r_square_matrix
      end
    end
  end
end
