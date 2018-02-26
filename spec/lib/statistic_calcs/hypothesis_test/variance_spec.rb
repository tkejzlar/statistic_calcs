# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/hypothesis_test/variance_spec.rb
require 'statistic_calcs/hypothesis_test/variance.rb'
require 'statistic_calcs/hypothesis_test/cases.rb'
require 'pry'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::HypothesisTest::Variance do
  context 'Known sigma mean' do
    subject { StatisticCalcs::HypothesisTest::Variance.new(options) }

    context 'Happy path' do
      before { subject.calc! }
      describe 'Unilateral - right - case1 test' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('sigma^2 <= s0 (400)')
          expect(subject.alternative_hypothesis).to eq('sigma^2 > s1 ()')
          expect(subject.critical_fractil).to eq(586.9926896551724)
          expect(subject.reject).to eq(false)
          expect(subject.reject_condition).to eq('S^2 > S^2c -> reject H0. `225 > 586.99` -> false')
        end
      end

      describe 'Unilateral - left - case2 test' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_2 } }

        it 'should fill all the attributes' do
          expect(subject.null_hypothesis).to eq('sigma^2 >= s0 (400)')
          expect(subject.alternative_hypothesis).to eq('sigma^2 < s1 ()')
          expect(subject.critical_fractil).to eq(244.2533793103448)
          expect(subject.reject).to eq(true)
          expect(subject.reject_condition).to eq('S^2 < S^2c -> reject H0. `225 < 244.25` -> true')
        end
      end
    end

    context 'Errors' do
      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 1.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, confidence_level: 1.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, beta: 1.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'beta/test_power should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, test_power: 1.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'beta/test_power should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 0.05, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`sample_variance` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.05, sample_variance: 225, variance_to_test: 400, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`sample_size` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_variance: 225, case: StatisticCalcs::HypothesisTest::Cases::CASE_1 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`variance_to_test` is required')
        end
      end

      describe 'raise validation error' do
        let(:options) { { sample_size: 30, alpha: 0.05, sample_variance: 225, variance_to_test: 400 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, '`case` is required')
        end
      end
    end
  end
end
# rubocop:enable BlockLength
