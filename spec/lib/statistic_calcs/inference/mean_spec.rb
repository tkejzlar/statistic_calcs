# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/inference/mean_spec.rb
require 'statistic_calcs/inference/known_sigma_mean.rb'
require 'statistic_calcs/inference/unknown_sigma_mean.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Inference::KnownSigmaMean do
  context 'Known sigma mean' do
    subject { StatisticCalcs::Inference::KnownSigmaMean.new(options) }

    context 'Happy path' do
      before { subject.calc! }
      describe 'calc to the population lower and upper limits' do
        let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_size: 10, sample_mean: 246.0 } }

        it 'should fill all the attributes' do
          expect(subject.lower_limit).to eq(238.19779138600805)
          expect(subject.upper_limit).to eq(253.80220861399195)
          expect(subject.sample_error).to eq(8)
        end
      end

      describe 'calc to the sample size with sample error' do
        let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0, sample_error: 5 } }

        it 'should fill all the attributes' do
          expect(subject.sample_size).to eq(25)
        end
      end

      describe 'finite population calc the sample size' do
        let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0, sample_error: 5, population_size: 900 } }

        it 'should fill all the attributes' do
          expect(subject.sample_size).to eq(25)
        end
      end
    end

    context 'Errors' do
      describe 'raise validation error' do
        let(:options) { { alpha: 1.01, standard_deviation: 15.0, sample_size: 10, sample_mean: 246.0 } }

        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'alpha should be between 0 and 1')
        end
      end

      describe 'raise validation error' do
        let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0 } }
        it 'should fill all the attributes' do
          expect { subject.calc! }.to raise_error(StandardError, 'sample_size or sample_error is required')
        end
      end
    end
  end

  context 'Unknown sigma mean' do
    subject { StatisticCalcs::Inference::UnknownSigmaMean.new(options) }

    before { subject.calc! }
    describe 'calc to the population lower and upper limits' do
      let(:options) { { alpha: 0.05, sample_standard_deviation: 1.7935, sample_size: 4, sample_mean: 17.35 } }

      it 'should fill all the attributes' do
        expect(subject.lower_limit).to eq(14.4961379625)
        expect(subject.upper_limit).to eq(20.203862037500002)
        expect(subject.sample_error).to eq(3)
      end
    end

    describe 'calc to the sample size with sample error' do
      let(:options) { { alpha: 0.05, sample_standard_deviation: 1.7935, sample_mean: 17.35, sample_error: 1 } }

      it 'should fill all the attributes' do
        expect(subject.sample_size).to eq(15)
      end
    end

    describe 'calc to the population lower and upper limits' do
      let(:options) { { alpha: 0.05, sample_standard_deviation: 1.7935, sample_size: 15, sample_mean: 17.35 } }

      it 'should fill all the attributes' do
        expect(subject.sample_error).to eq(1)
      end
    end
  end
end
# rubocop:enable BlockLength
