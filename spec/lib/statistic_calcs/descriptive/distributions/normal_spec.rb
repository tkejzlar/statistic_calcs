# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/normal_spec.rb
require 'statistic_calcs/descriptive/distributions/normal.rb'
require 'spec_helper'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Normal do
  subject { StatisticCalcs::Descriptive::Distributions::Normal.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { mean: 0, standard_deviation: 1, x: 1.64489 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.95)
      expect(subject.g_x).to eq(0.05)
      expect(subject.sigma).to eq(1)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { mean: 0, standard_deviation: 1, x: 1.44 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.92507)
      expect(subject.g_x).to eq(0.07493)
      expect(subject.sigma).to eq(1)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { mean: 47.9, standard_deviation: 1.33, x: 46.779 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.19965)
      expect(subject.g_x).to eq(0.80035)
      expect(subject.sigma).to eq(1.76890)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { mean: -6.4469, standard_deviation: 0.05, x: -6.556 } }

    it 'should fill all the attributes' do
      expect(subject.g_x).to eq(0.98545)
      expect(subject.f_x).to eq(0.01455)
      expect(subject.sigma).to eq(0.0025)
    end
  end
end
