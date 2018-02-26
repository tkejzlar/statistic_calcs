# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/hypothesis_test/standard_deviation_spec.rb
require 'statistic_calcs/hypothesis_test/standard_deviation.rb'
require 'statistic_calcs/hypothesis_test/cases.rb'
require 'pry'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::HypothesisTest::StandardDeviation do
  context 'Known sigma mean' do
    subject { StatisticCalcs::HypothesisTest::StandardDeviation.new(options) }

    context 'Happy path' do
      before { subject.calc! }
      describe 'Unilateral - right - case1 test' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('sigma <= s0 (20)')
          expect(subject.alternative_hypothesis).to eq('sigma > s1 ()')
          expect(subject.critical_fractil).to eq(24.227932013590685)
          expect(subject.reject).to eq(false)
          expect(subject.reject_condition).to eq('S > Sc -> reject H0. `15 > 24.23` -> false')
        end
      end

      describe 'Unilateral - left - case2 test' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_2 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('sigma >= s0 (20)')
          expect(subject.alternative_hypothesis).to eq('sigma < s1 ()')
          expect(subject.critical_fractil).to eq(15.628607721430107)
          expect(subject.reject).to eq(true)
          expect(subject.reject_condition).to eq('S < Sc -> reject H0. `15 < 15.63` -> true')
        end
      end
    end

    context 'Errors' do
      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 1.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, confidence_level: 1.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, beta: 1.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'beta/test_power should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, test_power: 1.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'beta/test_power should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 0.05, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`sample_standard_deviation` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, sample_standard_deviation: 15, standard_deviation_to_test: 20, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`sample_size` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_standard_deviation: 15, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`standard_deviation_to_test` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_standard_deviation: 15, standard_deviation_to_test: 20 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`case` is required')
        end
      end
    end
  end
end
# rubocop:enable BlockLength
