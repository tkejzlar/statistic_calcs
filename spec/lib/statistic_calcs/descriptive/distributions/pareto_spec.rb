# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/pareto_spec.rb
require 'statistic_calcs/descriptive/distributions/pareto.rb'
require 'spec_helper'

RSpec.describe StatisticCalcs::Descriptive::Distributions::Pareto do
  subject { StatisticCalcs::Descriptive::Distributions::Pareto.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { m: 45, alpha: 3, x: 55 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.45229)
      expect(subject.g_x).to eq(0.54771)
      expect(subject.mean).to eq(67.5)
      expect(subject.variance).to eq(1518.75)
      expect(subject.standard_deviation).to eq(38.97114)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { m: 4223.98, alpha: 23.983, x: 5024.114 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.9844)
      expect(subject.g_x).to eq(0.0156)
      expect(subject.mean).to eq(4_407.76715)
      expect(subject.variance).to eq(36_850.79146)
      expect(subject.standard_deviation).to eq(191.96560)
    end
  end
end
