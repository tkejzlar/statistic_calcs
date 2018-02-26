# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/hypothesis_test/log_normal_goodness_and_fit_spec.rb
require 'statistic_calcs/hypothesis_test/goodness_and_fit'
require 'statistic_calcs/chi_square_contrast/log_normal_goodness_and_fit'
require 'statistic_calcs/hypothesis_test/cases'
require 'pry'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::HypothesisTest::GoodnessAndFit do
  subject { StatisticCalcs::HypothesisTest::GoodnessAndFit.new(data: data) }
  let(:lower_class_boundary_values) { [0, 100, 200, 300, 400, 500, 600] }
  let(:upper_class_boundary_values) { [100, 200, 300, 400, 500, 600, 1400] }
  let(:observed_frequencies) { [15, 44, 38, 22, 14, 9, 2] }

  context 'Happy path' do
    before { subject.calc! }
    let!(:options) { { lower_class_boundary_values: lower_class_boundary_values, upper_class_boundary_values: upper_class_boundary_values, observed_frequencies: observed_frequencies } }
    let!(:data) { StatisticCalcs::ChiSquareContrast::LogNormalGoodnessAndFit.new(options) }
    describe 'Chi square contrast test' do
      it 'should fill all the attributes' do
        expect(subject.null_hypothesis).to eq('Xc^2 <= X^2(1 - alpha, V). 8.0608 <= 9.48773')
        expect(subject.alternative_hypothesis).to eq('Xc^2 > X^2')
        expect(subject.critical_fractil).to eq(8.0608)
        expect(subject.reject).to eq(false)
        expect(subject.reject_condition).to eq('Xc^2 > X^2 -> reject H0. `8.06 > 9.49` -> false')
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
