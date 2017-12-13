# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/binomial_spec.rb
require 'statistic_calcs/descriptive/distributions/binomial.rb'
require 'spec_helper'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Binomial do
  subject { StatisticCalcs::Descriptive::Distributions::Binomial.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { n: 20, r: 19, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20)
      expect(subject.r).to eq(19)
      expect(subject.p).to eq(0.9)
      expect(subject.p_x).to eq(0.27017)
      expect(subject.f_x).to eq(0.87842)
      expect(subject.g_x).to eq(0.39175)
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { n: 78, r: 55, p: 0.7623 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(78)
      expect(subject.r).to eq(55)
      expect(subject.p).to eq(0.7623)
      expect(subject.p_x).to eq(0.05052)
      expect(subject.f_x).to eq(0.14646)
      expect(subject.g_x).to eq(0.90406)
      expect(subject.mean).to eq(59.45940)
      expect(subject.variance).to eq(14.13350)
      expect(subject.standard_deviation).to eq(3.75945)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { n: 200, r: 60, p: 0.25 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(200)
      expect(subject.r).to eq(60)
      expect(subject.p).to eq(0.25)
      expect(subject.p_x).to eq(0.01708)
      expect(subject.f_x).to eq(0.95461)
      expect(subject.g_x).to eq(0.06247)
      expect(subject.mean).to eq(50)
      expect(subject.variance).to eq(37.5)
      expect(subject.standard_deviation).to eq(6.12372)
    end
  end

  describe 'calc to get r with f' do
    let(:options) { { n: 20, f_x: 0.87842, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(18)
      expect(subject.n).to eq(20)
      expect(subject.p).to eq(0.9)
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
    end
  end

  describe 'calc to get r with f with 0' do
    let(:options) { { n: 20, f_x: 0.0, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(0)
      expect(subject.n).to eq(20)
      expect(subject.p).to eq(0.9)
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
    end
  end

  describe 'calc to get r with g' do
    let(:options) { { n: 20, g_x: 0.87842, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(16)
      expect(subject.n).to eq(20)
      expect(subject.p).to eq(0.9)
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
    end
  end

  describe 'calc to get r with g with 0' do
    let(:options) { { n: 20, g_x: 0.0, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(20)
      expect(subject.n).to eq(20)
      expect(subject.p).to eq(0.9)
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
    end
  end
end
