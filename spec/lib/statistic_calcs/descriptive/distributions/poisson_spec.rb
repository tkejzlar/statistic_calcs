# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/poisson_spec.rb
require 'statistic_calcs/descriptive/distributions/poisson.rb'
require 'spec_helper'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Poisson do
  subject { StatisticCalcs::Descriptive::Distributions::Poisson.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { frequency: 25, time_period: 1, number_successes: 30 } }

    it 'should fill all the attributes' do
      expect(subject.p_x).to eq(0.04541)
      expect(subject.f_x).to eq(0.86331)
      expect(subject.g_x).to eq(0.18210)
      expect(subject.mean).to eq(25.0)
      expect(subject.variance).to eq(25.0)
      expect(subject.standard_deviation).to eq(5.0)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { frequency: 325, time_period: 1, number_successes: 288 } }

    it 'should fill all the attributes' do
      expect(subject.p_x).to eq(0.00263)
      expect(subject.f_x).to eq(0.01994)
      expect(subject.g_x).to eq(0.98269)
      expect(subject.mean).to eq(325.0)
      expect(subject.variance).to eq(325.0)
      expect(subject.standard_deviation).to eq(18.02776)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { frequency: 325, time_period: 0.1, number_successes: 28 } }

    it 'should fill all the attributes' do
      expect(subject.p_x).to eq(0.05420)
      expect(subject.f_x).to eq(0.24609)
      expect(subject.g_x).to eq(0.80811)
      expect(subject.mean).to eq(32.5)
      expect(subject.variance).to eq(32.5)
      expect(subject.standard_deviation).to eq(5.70088)
    end
  end
end
