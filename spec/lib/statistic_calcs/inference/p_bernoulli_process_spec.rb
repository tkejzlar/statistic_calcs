# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/inference/p_bernoulli_process.rb
require 'statistic_calcs/inference/p_bernoulli_process.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Inference::PBernoulliProcess do
  subject { StatisticCalcs::Inference::PBernoulliProcess.new(options) }

  context 'Happy path' do
    before { subject.calc! }
    describe 'calc the p lower and upper limits' do
      let(:options) { { alpha: 0.1, n: 30, r: 3 } }

      it 'should fill all the attributes' do
        expect(subject.lower_limit).to eq(0.02782)
        expect(subject.upper_limit).to eq(0.2386)
        expect(subject.sample_p).to eq(0.1)
        expect(subject.sample_error).to eq(0.10539)
      end
    end
  end

  context 'Errors' do
    describe 'raise validation error' do
      let(:options) { { alpha: 1.1, n: 30, r: 3 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, 'alpha should be between 0 and 1')
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, n: 30, r: 33 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, 'number_successes couldn\'t be greater than sample_size')
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, n: 30, r: -33 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, 'number_successes should be zero or more')
      end
    end

    describe 'raise validation error' do
      let(:options) { { alpha: 0.1, n: 0, r: 0 } }

      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, 'sample_size should be positive')
      end
    end
  end
end
# rubocop:enable BlockLength
