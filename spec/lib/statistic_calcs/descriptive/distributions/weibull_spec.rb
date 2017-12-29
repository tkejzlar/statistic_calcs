# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/weibull_spec.rb
require 'statistic_calcs/descriptive/distributions/weibull.rb'
require 'spec_helper'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Weibull do
  subject { StatisticCalcs::Descriptive::Distributions::Weibull.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { alpha: 14, beta: 25, x: 23.9 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(23.9)
      expect(subject.f_x).to eq(0.41293)
      expect(subject.g_x).to eq(0.58707)
      # TODO: check! mean and variance in android app eq(24.08774)
      expect(subject.mean).to eq(25.80829)
      expect(subject.variance).to eq(2.10164)
      expect(subject.standard_deviation).to eq(1.4497)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { alpha: 14, beta: 25, f_x: 0.41293 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(23.9)
      expect(subject.f_x).to eq(0.41293)
      expect(subject.g_x).to eq(0.58707)
      # TODO: check! mean and variance in android app eq(24.08774)
      expect(subject.mean).to eq(25.80829)
      expect(subject.variance).to eq(2.10164)
      expect(subject.standard_deviation).to eq(1.4497)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { alpha: 14, beta: 25, g_x: 0.58707 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(23.9)
      expect(subject.f_x).to eq(0.41293)
      expect(subject.g_x).to eq(0.58707)
      # TODO: check! mean and variance in android app eq(24.08774)
      expect(subject.mean).to eq(25.80829)
      expect(subject.variance).to eq(2.10164)
      expect(subject.standard_deviation).to eq(1.4497)
    end
  end
end
