# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/regression/multiple_linear_regression_spec.rb
require 'statistic_calcs/regression/multiple_linear_regression'

# rubocop:disable BlockLength
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

      it 'should fill the ANOVA' do
        # From excel
        # In analysis of variance (ANOVA) - Single Factor
        # Alpha 0.05

        # Groups  Count Sum Mean   Variance
        # Column 1  5   33  6.6    4.3
        # Column 2  5   15  3      2.5
        # Column 3      23  4.6   10.8

        expect(subject.n).to eq(5)
        expect(subject.x_values_mean_matrix.to_a).to eq([3.0, 4.6])
        expect(subject.y_values_mean).to eq(6.6)
        expect(subject.x_values_sum_matrix.to_a).to eq([15.0, 23.0])
        expect(subject.y_values_sum).to eq(33.0)
        expect(subject.x_values_variance_matrix.to_a).to eq([2.5, 10.8])
        expect(subject.y_values_variance).to eq(4.3)
      end

      it 'should calculate the linest formula' do
        # Excel linest formula `=LINEST(A2:A6,B2:C6,1, 1)`
        # 0.0361445783  -1.2361445783   10.1421686747 --> Slopes and intercept
        # 0.203753428    0.4234935474   1.273744148 ----> Standard errors/deviations
        # 0.8397310171   1.1740158657   #N/A -----------> R^2 coefficients, Stand error Y
        # 5.2395104895   2   #N/A  ---------------------> F observed, degrees of freedom
        # 14.443373494   2.756626506  #N/A -------------> Sum squares, Residual sum squares

        expect(subject.b_values[:b2]).to eq(0.03614457831325301) # slope b2
        expect(subject.b_values[:b1]).to eq(-1.236144578313253) # slope b1
        expect(subject.b_values[:b0]).to eq(10.142168674698794) # intercept b0

        expect(subject.b_values_standard_errors[:b2]).to eq(0.20375342801551521)
        expect(subject.b_values_standard_errors[:b1]).to eq(0.42349354744704026)
        expect(subject.b_values_standard_errors[:b0]).to eq(1.2737441479548088)

        expect(subject.r_square).to eq(0.8397310170916223)
        expect(subject.y_standard_error).to eq(1.1740158657411952)

        expect(subject.f_observed).to eq(5.23951048951049)
        expect(subject.degrees_of_freedom).to eq(2)

        expect(subject.sum_squares).to eq(14.443373493975903)
        expect(subject.residual_sum_squares).to eq(2.756626506024096)

        # also
        expect(subject.total_sum_squares).to eq(17.2)
        expect(subject.r).to eq(0.9163683850349827)
      end

      it 'should get useful info' do
        expect(subject.min_standard_deviation).to eq('x1')
        expect(subject.max_standard_deviation).to eq('x2')
        expect(subject.min_skew).to eq('x1')
        expect(subject.max_skew).to eq('x2')
        expect(subject.min_kurtosis).to eq('x2')
        expect(subject.max_kurtosis).to eq('x1')
      end

      it 'should get the covariance matrix' do
        # excel covariance matrix
        # Column 1  Column 2  Column 3
        # Column 1  3.44
        # Column 2  -2.4  2
        # Column 3  -2.16  2  8.64
        expect(subject.covariance_matrix.to_a).to eq([[3.44, -2.4, -2.16], [-2.4, 2.0, 2.0], [-2.16, 2.0, 8.64]])
      end

      it 'should get the correlation matrix' do
        # excel correlation matrix
        # Column 1  Column 2  Column 3
        # Column 1  1
        # Column 2  -0.914991422  1
        # Column 3  -0.396202908  0.481125224  1
        expect(subject.correlation_matrix.to_a).to eq([[1.0, -0.914991421995628, -0.3962029078465307], [-0.914991421995628, 1.0, 0.48112522432468807], [-0.3962029078465307, 0.48112522432468807, 1.0]])
      end

      it 'should get the r square matrix' do
        # excel
        # 1.0,   0.837, 0.156
        # 0.837, 1.0,   0.231
        # 0.156, 0.231, 1.0
        expect(subject.r_square_matrix.to_a).to eq([[1.0, 0.8372093023255814, 0.1569767441860465], [0.8372093023255814, 1.0, 0.23148148148148143], [0.1569767441860465, 0.23148148148148143, 1.0]])
      end

      it 'should get the x values standard deviation matrix' do
        expect(subject.x_values_standard_deviation_matrix.to_a).to eq([1.5811388300841898, 3.286335345030997])
      end

      it 'should get the adjusted R matrix' do
        # TODO: adjusted R
        # expect(subject.adj_r_square_matrix.to_a).to eq([[1.0, 0.17499999999999993, -0.5], [0.17499999999999993, 1.0, -0.125], [-0.5, -0.125, 1.0]])
        # # 1.0   , 0.174,  -0.5
        # # 0.174 , 1.0   , -0.125
        # # -0.5 , -0.125,   1.0
        expect(subject.r).to eq(0.9163683850349827)
      end

      it 'should get the result matrix' do
        expect(subject.valid_correlation_for_social_problems?).to be_truthy
        expect(subject.valid_correlation_for_economic_problems?).to be_truthy
        expect(subject.valid_correlation_for_tech_problems?).to be_truthy
        expect(subject.equation).to eq('y = 10.142 - 1.2361 x1 + 0.0361 x2')
      end
    end
  end
end
# rubocop:enable BlockLength
