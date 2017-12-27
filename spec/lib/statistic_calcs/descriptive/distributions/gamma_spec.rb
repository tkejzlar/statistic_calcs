# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/gamma_spec.rb
require 'statistic_calcs/descriptive/distributions/gamma.rb'
require 'spec_helper'

RSpec.describe StatisticCalcs::Descriptive::Distributions::Gamma do
  subject { StatisticCalcs::Descriptive::Distributions::Gamma.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { a: 5, b: 33, x: 0.25 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.25)
      expect(subject.f_x).to eq(0.91381)
      expect(subject.g_x).to eq(0.08619)
      expect(subject.mean).to eq(0.15152)
      expect(subject.variance).to eq(0.00459)
      expect(subject.standard_deviation).to eq(0.06776)
    end
  end

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { a: 5, b: 33, f_x: 0.91381 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.25)
      expect(subject.f_x).to eq(0.91381)
      expect(subject.g_x).to eq(0.08619)
      expect(subject.mean).to eq(0.15152)
      expect(subject.variance).to eq(0.00459)
      expect(subject.standard_deviation).to eq(0.06776)
    end
  end

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { a: 5, b: 33, g_x: 0.08619 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.25)
      expect(subject.f_x).to eq(0.91381)
      expect(subject.g_x).to eq(0.08619)
      expect(subject.mean).to eq(0.15152)
      expect(subject.variance).to eq(0.00459)
      expect(subject.standard_deviation).to eq(0.06776)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { a: 1, b: 2, x: 3 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(3)
      expect(subject.f_x).to eq(0.99752)
      expect(subject.g_x).to eq(0.00248)
      expect(subject.mean).to eq(0.5)
      expect(subject.variance).to eq(0.25)
      expect(subject.standard_deviation).to eq(0.5)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { a: 1, b: 2, f_x: 0.99752 } }
    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(3)
      expect(subject.f_x).to eq(0.99752)
      expect(subject.g_x).to eq(0.00248)
      expect(subject.mean).to eq(0.5)
      expect(subject.variance).to eq(0.25)
      expect(subject.standard_deviation).to eq(0.5)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { a: 1, b: 2, g_x: 0.00248 } }
    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(3)
      expect(subject.f_x).to eq(0.99752)
      expect(subject.g_x).to eq(0.00248)
      expect(subject.mean).to eq(0.5)
      expect(subject.variance).to eq(0.25)
      expect(subject.standard_deviation).to eq(0.5)
    end
  end
end
