# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/regression/multiple_linear_regression_matrix_calc_spec.rb
require 'statistic_calcs/regression/multiple_linear_regression'

RSpec.describe StatisticCalcs::Regression::MultipleLinearRegression do
  subject { StatisticCalcs::Regression::MultipleLinearRegression.new(options) }

  context 'Happy path' do
    before { subject.calc! }
    describe 'matrix calcs' do
      let(:options) { { x_values: x_values, y_values: y_values } }
      let(:x1_values) { [1, 2, 3, 4, 5] }
      let(:x2_values) { [1, 3, 7, 9, 3] }
      let(:x_values) { [x1_values, x2_values] }
      let(:y_values) { [8, 9, 7, 5, 4] }

      it 'should fill all the attributes' do
        expect(subject.x_matrix.to_a).to eq([[1, 1, 1], [1, 2, 3], [1, 3, 7], [1, 4, 9], [1, 5, 3]])
        expect(subject.x_matrix_transposed.to_a).to eq([[1, 1, 1, 1, 1], [1, 2, 3, 4, 5], [1, 3, 7, 9, 3]])
        expect(subject.x_matrix_transposed_by_x_matrix.to_a).to eq([[5, 15, 23], [15, 55, 79], [23, 79, 149]])
        expect(subject.x_matrix_transposed_by_x_matrix_inv.to_a).to eq([[(977.0 / 830), (-209.0 / 830), (-4.0 / 83)], [(-209.0 / 830), (54.0 / 415), (-5.0 / 166)], [(-4.0 / 83), (-5.0 / 166), (5.0 / 166)]])
        # 1.177108434  -0.251807229  -0.048192771
        # -0.251807229  0.130120482  -0.030120482
        # -0.048192771  -0.030120482  0.030120482
        expect(subject.x_matrix_transposed_by_y_matrix.to_a.flatten).to eq([33, 87, 141])
        expect(subject.x_matrix_transposed_by_x_matrix_inv_by_x_matrix_transposed_by_y_matrix.to_a).to eq([[(4209.0 / 415)], [(-513.0 / 415)], [(3.0 / 83)]])
        # 10.14216867, -1.236144578, 0.036144578
        # b0         , b1         , b2
      end
    end
  end
end
