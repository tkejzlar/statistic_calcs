# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/inference/standard_deviation_spec.rb
require 'statistic_calcs/inference/standard_deviation.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Inference::StandardDeviation do
  subject { StatisticCalcs::Inference::StandardDeviation.new(options) }

  context 'Happy path' do
    before { subject.calc! }
    describe 'calc to the population lower and upper limits' do
      let(:options) { { alpha: 0.1, sample_standard_deviation: 120, sample_size: 15 } }

      it 'should fill all the attributes' do
        expect(subject.lower_limit).to eq(92.25937212461747)
        expect(subject.upper_limit).to eq(175.16275117237933)
        expect(subject.limits_relationship_standard_deviation).to eq(1.8985903235476371)
        expect(subject.degrees_of_freedom).to eq(14)
        expect(subject.sample_error).to eq(41.45168952388093)
      end
    end

    describe 'calc to the population lower and upper limits' do
      let(:options) { { alpha: 0.1, sample_standard_deviation: 0.1924, sample_size: 5 } }

      it 'should fill all the attributes' do
        expect(subject.lower_limit).to eq(0.12492630786356203)
        expect(subject.upper_limit).to eq(0.4564422052327049)
        expect(subject.limits_relationship_standard_deviation).to eq(3.653691628597614)
        expect(subject.degrees_of_freedom).to eq(4)
        expect(subject.sample_error).to eq(0.16575794868457144)
      end
    end

    describe 'calc to the sample size with sample error' do
      let(:options) { { alpha: 0.1, sample_standard_deviation: 120, limits_relationship_standard_deviation: 2 } }

      it 'should fill all the attributes' do
        expect(subject.sample_size).to eq(14)
        expect(subject.degrees_of_freedom).to eq(13)
      end
    end
  end

  context 'Errors' do
    describe 'raise validation error' do
      let(:options) { { alpha: 1.1, sample_standard_deviation: 14_400, sample_size: 15 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError)
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, sample_standard_deviation: 14_400 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError)
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, sample_standard_deviation: 14_400, limits_relationship_standard_deviation: 1 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError)
      end
    end
  end
end
# rubocop:enable BlockLength
