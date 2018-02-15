# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/regression_theory/simple_lineal_regression_spec.rb
require 'statistic_calcs/regression_theory/simple_lineal_regression.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::RegressionTheory::SimpleLinealRegression do
  subject { StatisticCalcs::RegressionTheory::SimpleLinealRegression.new(options) }

  context 'Happy path' do
    before { subject.calc! }
    describe 'calc to the population lower and upper limits' do
      let(:options) { { x_values: x_values, y_values: y_values } }
      let(:x_values) { [3.0402, 2.9819, 3.0934, 3.805, 5.423] }
      let(:y_values) { [8.014, 7.891, 8.207, 8.31, 8.45] }

      it 'should fill all the attributes' do
        expect(subject.b1).to eq(0.18134495612017704) # slope
        expect(subject.b0).to eq(7.509099759481907) # intercept
        expect(subject.n).to eq(5)
        expect(subject.degrees_of_freedom).to eq(3)

        expect(subject.x_values_mean).to eq(3.66870)
        expect(subject.x_values_square_sum).to eq(71.59062121)
        expect(subject.x_values_sum).to eq(18.3435)

        expect(subject.xy_values_sum).to eq(150.7257695)

        expect(subject.y_values_mean).to eq(8.1744)
        expect(subject.y_values_square_sum).to eq(334.305526)
        expect(subject.y_values_sum).to eq(40.872)

        expect(subject.r).to eq(0.8372299658466078) # pearson_correlation_coefficient
        expect(subject.r_square).to eq(0.7009540157115121)
        expect(subject.r_square_adj).to eq(0.7009540157115121)
        expect(subject.covariance).to eq(0.15573262000000554)
        expect(subject.variance).to eq(1.07346)
        expect(subject.standard_deviation).to eq(1.0360770675968076)

        expect(subject.valid_correlation_for_social_problems?).to be_truthy
        expect(subject.valid_correlation_for_economic_problems?).to be_truthy
        expect(subject.valid_correlation_for_tech_problems?).to be_falsey
        expect(subject.equation).to eq('y = 7.509 + 0.181 x')
      end
    end
  end

  context 'Errors' do
    describe 'raise validation error' do
      let(:options) { { y_values: [] } }

      it 'raise validation error' do
        expect { subject.calc! }.to raise_error(StandardError, 'y_values should have some values')
      end
    end

    describe 'raise validation error' do
      let(:options) { { y_values: [1, 'a'] } }

      it 'raise validation error' do
        expect { subject.calc! }.to raise_error(StandardError, 'y_values is not a valid list of float')
      end
    end

    describe 'raise validation error' do
      let(:options) { { x_values: [2], y_values: [2, 3] } }

      it 'raise validation error' do
        expect { subject.calc! }.to raise_error(StandardError, 'y_values & x_values should have the same amount of values')
      end
    end
  end
end
# rubocop:enable BlockLength
