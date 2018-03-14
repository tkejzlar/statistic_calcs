# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/regression/multiple_linear_regression_multicollinearity_analysis_spec.rb
require 'statistic_calcs/regression/multiple_linear_regression'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Regression::MultipleLinearRegression do
  subject { StatisticCalcs::Regression::MultipleLinearRegression.new(options) }
  context 'Happy path' do
    before { subject.calc! }
    describe 'matrix calcs' do
      let(:options) { { x_values: x_values, y_values: y_values } }
      let(:x1_values) { [1, 2.5, 3.1, 4, 4.7, 5.3, 6, 7.1, 9] }
      let(:x2_values) { [9, 12, 13, 14, 14.5, 16, 17, 19, 19.6] }
      let(:x3_values) { [3, 4, 5, 2, 4, 8, 12, 10, 23.2] }
      let(:x_values) { [x1_values, x2_values, x3_values] }
      let(:y_values) { [5, 8.5, 10, 11.2, 14, 16, 16.8, 18.55, 20] }

      it 'should fill all the attributes' do
        expect(subject.n).to eq(9)
        expect(subject.parameters_count).to eq(3)
        expect(subject.possible_scenarios_amount).to eq(7)
        expect(subject.possible_scenarios).to eq([['x1'], ['x2'], ['x3'], %w[x1 x2], %w[x1 x3], %w[x2 x3], %w[x1 x2 x3]])
        expect(subject.possible_scenarios_keys).to eq(%w[x1 x2 x3 x1x2 x1x3 x2x3 x1x2x3])

        analysis = subject.multicollinearity_analysis
        # x1
        expect(subject.x_possible_matrixes[0].to_a).to eq([[5, 1, 1], [8.5, 1, 2.5], [10, 1, 3.1], [11.2, 1, 4], [14, 1, 4.7], [16, 1, 5.3], [16.8, 1, 6], [18.55, 1, 7.1], [20, 1, 9]])
        expect(analysis[0]).to eq(name: 'x1', indexes: [0], delta_sum: 10.680244233697847, prediction_sum_square: 21.281654989684192, r_square: 0.9558856309104158, s_square: 1.2585129273178306, det: 1, p: 2, c_p: 5.231348981603828)
        # x2
        expect(subject.x_possible_matrixes[1].to_a).to eq([[5, 1, 9], [8.5, 1, 12], [10, 1, 13], [11.2, 1, 14], [14, 1, 14.5], [16, 1, 16], [16.8, 1, 17], [18.55, 1, 19], [20, 1, 19.6]])
        expect(analysis[1]).to eq(name: 'x2', indexes: [1], delta_sum: 7.2750951782975175, prediction_sum_square: 7.025582495143389, r_square: 0.9754802853977655, s_square: 0.6995085374198792, det: 1, p: 2, c_p: 0.686803692360185)
        # x3
        expect(subject.x_possible_matrixes[2].to_a).to eq([[5, 1, 3], [8.5, 1, 4], [10, 1, 5], [11.2, 1, 2], [14, 1, 4], [16, 1, 8], [16.8, 1, 12], [18.55, 1, 10], [20, 1, 23.2]])
        expect(analysis[2]).to eq(name: 'x3', indexes: [2], delta_sum: 35.603361186130876, prediction_sum_square: 205.4174659315566, r_square: 0.6065514519497733, s_square: 11.22446255436875, det: 1, p: 2, c_p: 86.25165982159868)
        # x1x2
        expect(subject.x_possible_matrixes[3].to_a).to eq([[5, 1, 1, 9], [8.5, 1, 2.5, 12], [10, 1, 3.1, 13], [11.2, 1, 4, 14], [14, 1, 4.7, 14.5], [16, 1, 5.3, 16], [16.8, 1, 6, 17], [18.55, 1, 7.1, 19], [20, 1, 9, 19.6]])
        expect(analysis[3]).to eq(name: 'x1x2', indexes: [0, 1], delta_sum: 11.134037093454548, prediction_sum_square: 27.189249710539283, r_square: 0.9769708817060959, s_square: 0.7664815558972822, det: 0.03438568051018753, p: 3, c_p: 2.3410929560183007)
        # x1x3
        expect(subject.x_possible_matrixes[4].to_a).to eq([[5, 1, 1, 3], [8.5, 1, 2.5, 4], [10, 1, 3.1, 5], [11.2, 1, 4, 2], [14, 1, 4.7, 4], [16, 1, 5.3, 8], [16.8, 1, 6, 12], [18.55, 1, 7.1, 10], [20, 1, 9, 23.2]])
        expect(analysis[4]).to eq(name: 'x1x3', indexes: [0, 2], delta_sum: 10.376422669511767, prediction_sum_square: 28.581199469696294, r_square: 0.97028723486526, s_square: 0.9889343638707381, det: 0.26151360553496095, p: 3, c_p: 3.8912165259489804)
        # x2x3
        expect(subject.x_possible_matrixes[5].to_a).to eq([[5, 1, 9, 3], [8.5, 1, 12, 4], [10, 1, 13, 5], [11.2, 1, 14, 2], [14, 1, 14.5, 4], [16, 1, 16, 8], [16.8, 1, 17, 12], [18.55, 1, 19, 10], [20, 1, 19.6, 23.2]])
        expect(analysis[5]).to eq(name: 'x2x3', indexes: [1, 2], delta_sum: 8.929718305470399, prediction_sum_square: 9.995741309076465, r_square: 0.9755001994152269, s_square: 0.8154304924631343, det: 0.38260199537423323, p: 3, c_p: 2.6821850779160066)
        # x1x2x3
        expect(subject.x_possible_matrixes[6].to_a).to eq([[5, 1, 1, 9, 3], [8.5, 1, 2.5, 12, 4], [10, 1, 3.1, 13, 5], [11.2, 1, 4, 14, 2], [14, 1, 4.7, 14.5, 4], [16, 1, 5.3, 16, 8], [16.8, 1, 6, 17, 12], [18.55, 1, 7.1, 19, 10], [20, 1, 9, 19.6, 23.2]])
        expect(analysis[6]).to eq(name: 'x1x2x3', indexes: [0, 1, 2], delta_sum: 14.146476480400466, prediction_sum_square: 45.17151816650524, r_square: 0.9784415675934314, s_square: 0.8610389995556437, det: 0.005546447654316999, p: 4, c_p: 4)
      end
    end
  end
end
# rubocop:enable BlockLength
