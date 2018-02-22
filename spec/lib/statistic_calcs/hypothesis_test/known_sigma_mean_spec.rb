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
          expect(subject.reject_condition).to eq('Xc1 < X < Xc2-> reject H0. `240.7 < 230.0 < 259.3` -> true')
        end
      end
      # describe 'calc to the sample size with sample error' do
      #   let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0, sample_error: 5 } }

      #   it 'should fill all the attributes' do
      #     expect(subject.sample_size).to eq(25)
      #   end
      # end

      # describe 'finite population calc the sample size' do
      #   let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0, sample_error: 5, population_size: 900 } }

      #   it 'should fill all the attributes' do
      #     expect(subject.sample_size).to eq(25)
      #   end
      # end
    end

    # context 'Errors' do
    #   describe 'raise validation error' do
    #     let(:options) { { alpha: 1.01, standard_deviation: 15.0, sample_size: 10, sample_mean: 246.0 } }

    #     it 'should fill all the attributes' do
    #       expect { subject.calc! }.to raise_error(StandardError, 'alpha should be between 0 and 1')
    #     end
    #   end

    #   describe 'raise validation error' do
    #     let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0 } }
    #     it 'should fill all the attributes' do
    #       expect { subject.calc! }.to raise_error(StandardError, 'sample_size or sample_error is required')
    #     end
    #   end
    # end
  end
end
# rubocop:enable BlockLength
