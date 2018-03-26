# frozen_string_literal: true

require 'matrix'

module StatisticCalcs
  module Regression
    module MatrixPearsonCoefficientCalculation
      # rubocop:disable MethodLength
      def generate_r_matrixes
        size = parameters_count + 1
        r_vectors = Array.new(size) { Array.new(size) }
        r2_vectors = Array.new(size) { Array.new(size) }
        r2_adj_vectors = Array.new(size) { Array.new(size) }
        covariance_matrix.each_with_index do |_value, row, col|
          numerator = covariance_matrix[row, col]
          divisor = covariance_matrix[row, row] * covariance_matrix[col, col]
          r = numerator / divisor**0.5
          r2 = r**2
          r_vectors[row][col] = r
          r2_vectors[row][col] = r2
          r2_adj_vectors[row][col] = 1 - ((1 - r2) * ((n - 1).to_f / (n - parameters_count)))
        end
        @correlation_matrix = Matrix.columns(r_vectors)
        @r_square_matrix = Matrix.columns(r2_vectors)
        @adj_r_square_matrix = Matrix.columns(r2_adj_vectors)
      end
      # rubocop:enable MethodLength
    end
  end
end
