# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/inference/mean_spec.rb
require 'statistic_calcs/inference/known_sigma_mean.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Inference::KnownSigmaMean do
  subject { StatisticCalcs::Inference::KnownSigmaMean.new(options) }

  before { subject.calc! }
  describe 'calc to the population lower and upper limits' do
    let(:options) { { alpha: 0.1, standard_deviation: 15.0, sample_size: 10, sample_mean: 246.0 } }

    it 'should fill all the attributes' do
      expect(subject.lower_limit).to eq(239.9210745969168)
      expect(subject.upper_limit).to eq(252.0789254030832)
      expect(subject.sample_error).to eq(7)
    end
  end
end

#TODO: Check Java spec values
# expect(subject.lower_limit).to eq(238.19777418186663)
# expect(subject.upper_limit).to eq(253.80222581813337)
# expect(subject.sample_error).to eq(8)
