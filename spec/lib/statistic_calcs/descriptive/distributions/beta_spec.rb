# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/beta_spec.rb
require 'statistic_calcs/descriptive/distributions/beta.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Beta do
  subject { StatisticCalcs::Descriptive::Distributions::Beta.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { alpha: 55, beta: 40, x: 0.53 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.53)
      expect(subject.f_x).to eq(0.16678)
      expect(subject.g_x).to eq(0.83322)
      expect(subject.mean).to eq(0.57895)
      expect(subject.variance).to eq(0.00254)
      expect(subject.standard_deviation).to eq(0.05039)
    end
  end

  describe 'calc fractil to get x with f' do
    let(:options) { { alpha: 55, beta: 40, f_x: 0.16678 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.53)
      expect(subject.f_x).to eq(0.16678)
      expect(subject.g_x).to eq(0.83322)
      expect(subject.mean).to eq(0.57895)
      expect(subject.variance).to eq(0.00254)
      expect(subject.standard_deviation).to eq(0.05039)
    end
  end

  describe 'calc fractil to get x with f' do
    let(:options) { { alpha: 55, beta: 40, g_x: 0.83322 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.53)
      expect(subject.f_x).to eq(0.16678)
      expect(subject.g_x).to eq(0.83322)
      expect(subject.mean).to eq(0.57895)
      expect(subject.variance).to eq(0.00254)
      expect(subject.standard_deviation).to eq(0.05039)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { alpha: 2, beta: 40, x: 0.053 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.64669)
      expect(subject.g_x).to eq(0.35331)
      expect(subject.mean).to eq(0.04762)
      expect(subject.variance).to eq(0.00105)
      expect(subject.standard_deviation).to eq(0.03248)
    end
  end

  describe 'calc fractil to get x with f' do
    let(:options) { { alpha: 2, beta: 40, f_x: 0.64669 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.053)
      expect(subject.f_x).to eq(0.64669)
      expect(subject.g_x).to eq(0.35331)
      expect(subject.mean).to eq(0.04762)
      expect(subject.variance).to eq(0.00105)
      expect(subject.standard_deviation).to eq(0.03248)
    end
  end

  describe 'calc fractil to get x with f' do
    let(:options) { { alpha: 2, beta: 40, f_x: 0.64669 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.053)
      expect(subject.f_x).to eq(0.64669)
      expect(subject.g_x).to eq(0.35331)
      expect(subject.mean).to eq(0.04762)
      expect(subject.variance).to eq(0.00105)
      expect(subject.standard_deviation).to eq(0.03248)
    end
  end
end
# rubocop:enable BlockLength
