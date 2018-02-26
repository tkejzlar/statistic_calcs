# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/hypothesis_test/known_sigma_mean_spec.rb
require 'statistic_calcs/hypothesis_test/known_sigma_mean.rb'
require 'statistic_calcs/hypothesis_test/cases.rb'
require 'pry'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::HypothesisTest::KnownSigmaMean do
  context 'Known sigma mean' do
    subject { StatisticCalcs::HypothesisTest::KnownSigmaMean.new(options) }

    context 'Happy path' do
      before { subject.calc! }
      describe 'Unilateral - right - case1 test' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('mean <= x0 (250)')
          expect(subject.alternative_hypothesis).to eq('mean > x1 ()')
          expect(subject.critical_fractil).to eq(257.8022086139919)
          expect(subject.reject).to eq(false)
          expect(subject.reject_condition).to eq('X > Xc -> reject H0. `230.0 > 257.8` -> false')
        end
      end

      describe 'Unilateral - left - case2 test' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_2 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('mean >= x0 (250)')
          expect(subject.alternative_hypothesis).to eq('mean < x1 ()')
          expect(subject.critical_fractil).to eq(242.19779138600805)
          expect(subject.reject).to eq(true)
          expect(subject.reject_condition).to eq('X < Xc -> reject H0. `230.0 < 242.2` -> true')
        end
      end

      describe 'Unilateral - left - case2 test' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_3 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('mean = x0 (250)')
          expect(subject.alternative_hypothesis).to eq('mean >< x1 ()')
          expect(subject.lower_critical_fractil).to eq(240.70309341576458)
          expect(subject.upper_critical_fractil).to eq(259.29690658423544)
          expect(subject.reject).to eq(true)
          expect(subject.reject_condition).to eq('X > Xc1 or X < Xc2-> reject H0. `230.0 > 240.7 or 230.0 < 259.3` -> true')
        end
      end
    end

    context 'Errors' do
      describe 'raise validation error' do
        let(:options) { { alpha: 1.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { confidence_level: 1.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { beta: 1.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'beta/test_power should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { test_power: 1.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'beta/test_power should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, sample_size: 10, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`standard_deviation` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_mean: 230.0, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`sample_size` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_size: 10, mean_to_test: 250, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`sample_mean` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`mean_to_test` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, standard_deviation: 15.0, sample_size: 10, sample_mean: 230.0, mean_to_test: 250 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`case` is required')
        end
      end
    end
  end
end
# rubocop:enable BlockLength
