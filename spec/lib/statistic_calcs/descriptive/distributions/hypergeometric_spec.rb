# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/hypergeometric_spec.rb
require 'statistic_calcs/descriptive/distributions/hypergeometric.rb'
require 'spec_helper'

RSpec.describe StatisticCalcs::Descriptive::Distributions::Hypergeometric do
  subject { StatisticCalcs::Descriptive::Distributions::Hypergeometric.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { n: 25, population_size: 36, total_number_successes: 34, x: 24 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(25)
      expect(subject.population_size).to eq(36)
      expect(subject.total_number_successes).to eq(34)
      expect(subject.x).to eq(24)

      expect(subject.p_x).to eq(0.43651)
      expect(subject.f_x).to eq(0.91270)
      expect(subject.g_x).to eq(0.52381)
      expect(subject.mean).to eq(23.61111)
      # TODO: FIX expect(subject.variance).to eq(0.41226)
      # expect(subject.standard_deviation).to eq(0.64207)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { n: 25, population_size: 105, total_number_successes: 100, x: 24 } }

    it 'should fill all the attributes' do
      expect(subject.p_x).to eq(0.40948)
      expect(subject.f_x).to eq(0.75104)
      expect(subject.g_x).to eq(0.65844)
      expect(subject.mean).to eq(23.80952)
      # TODO: FIX expect(subject.variance).to eq(0.87214)
      # expect(subject.standard_deviation).to eq(0.93389)
    end
  end
end
