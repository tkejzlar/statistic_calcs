# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/distributions/gumbel_minimum_spec.rb
require 'statistic_calcs/distributions/gumbel_minimum'

RSpec.describe StatisticCalcs::Distributions::GumbelMinimum do
  subject { StatisticCalcs::Distributions::GumbelMinimum.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { thita: 2, beta: 3, x: 1 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.51156)
      expect(subject.g_x).to eq(0.48844)
      expect(subject.mean).to eq(3.73165)
      expect(subject.variance).to eq(14.80441)
      expect(subject.standard_deviation).to eq(3.84765)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { location: 2, scale: 3, x: 1 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.51156)
      expect(subject.g_x).to eq(0.48844)
      expect(subject.mean).to eq(3.73165)
      expect(subject.variance).to eq(14.80441)
      expect(subject.standard_deviation).to eq(3.84765)
    end
  end
end
