# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/hypothesis_test/gumbel_minimum_goodness_and_fit_spec.rb
require 'statistic_calcs/hypothesis_test/goodness_and_fit'
require 'statistic_calcs/chi_square_contrast/gumbel_minimum_goodness_and_fit'
require 'statistic_calcs/hypothesis_test/cases'
require 'pry'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::HypothesisTest::GoodnessAndFit do
  subject { StatisticCalcs::HypothesisTest::GoodnessAndFit.new(data: data) }
  let(:lower_class_boundary_values) { [0, 15, 30, 45, 60, 75, 105] }
  let(:upper_class_boundary_values) { [15, 30, 45, 60, 75, 105, 200] }
  let(:observed_frequencies) { [8, 20, 25, 35, 25, 18, 0] }

  context 'Happy path' do
    before { subject.calc! }
    let!(:options) { { lower_class_boundary_values: lower_class_boundary_values, upper_class_boundary_values: upper_class_boundary_values, observed_frequencies: observed_frequencies } }
    let!(:data) { StatisticCalcs::ChiSquareContrast::GumbelMinimumGoodnessAndFit.new(options) }
    describe 'Chi square contrast test' do
      it 'should fill all the attributes' do
        expect(subject.null_hypothesis).to eq('Xc^2 <= X^2(1 - alpha, V). 206.1952 <= 9.48773')
        expect(subject.alternative_hypothesis).to eq('Xc^2 > X^2')
        expect(subject.critical_fractil).to eq(206.1952)
        expect(subject.reject).to eq(true)
        expect(subject.reject_condition).to eq('Xc^2 > X^2 -> reject H0. `206.2 > 9.49` -> true')
      end
    end
  end

  context 'Errors' do
    describe 'raise validation error' do
      subject { StatisticCalcs::HypothesisTest::GoodnessAndFit.new(options) }
      let(:options) { { alpha: 1.05 } }
      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
      end
    end

    describe 'raise validation error' do
      let!(:data) {}
      let(:options) { { alpha: 0.95 } }
      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, '`data` is required')
      end
    end

    describe 'raise validation error' do
      let!(:data) { [1, 2] }
      let(:options) { { alpha: 0.95 } }
      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, '`data` should be a `StatisticCalcs::ChiSquareContrast::GoodnessAndFit` object')
      end
    end
  end
end
# rubocop:enable BlockLength
