# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/inference/variance_spec.rb
require 'statistic_calcs/inference/variance.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Inference::Variance do
  subject { StatisticCalcs::Inference::Variance.new(options) }

  context 'Happy path' do
    before { subject.calc! }
    describe 'calc to the population lower and upper limits' do
      let(:options) { { alpha: 0.1, sample_variance: 14_400, sample_size: 15 } }

      it 'should fill all the attributes' do
        expect(subject.lower_limit).to eq(8_511.791744828643)
        expect(subject.upper_limit).to eq(30_681.989398276877)
        expect(subject.limits_relationship_variance).to eq(3.6046452166687213)
        expect(subject.degrees_of_freedom).to eq(14)
        expect(subject.sample_error).to eq(11_085.098826724117)
      end
    end

    describe 'calc to the population lower and upper limits' do
      let(:options) { { alpha: 0.1, sample_variance: 0.03701776, sample_size: 5 } }

      it 'should fill all the attributes' do
        expect(subject.lower_limit).to eq(0.01560658239642148)
        expect(subject.upper_limit).to eq(0.2083394867176947)
        expect(subject.limits_relationship_variance).to eq(13.349462516884287)
        expect(subject.degrees_of_freedom).to eq(4)
        expect(subject.sample_error).to eq(0.0963664521606366)
      end
    end

    describe 'calc to the sample size with sample error' do
      let(:options) { { alpha: 0.1, sample_variance: 14_400, limits_relationship_variance: 4 } }

      it 'should fill all the attributes' do
        expect(subject.sample_size).to eq(14)
        expect(subject.degrees_of_freedom).to eq(13)
      end
    end
  end

  context 'Errors' do
    describe 'raise validation error' do
      let(:options) { { alpha: 1.1, sample_variance: 14_400, sample_size: 15 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError)
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, sample_variance: 14_400 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError)
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, sample_variance: 14_400, limits_relationship_variance: 1 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError)
      end
    end
  end
end
# rubocop:enable BlockLength
