# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/distributions/chi_square_spec.rb
require 'statistic_calcs/distributions/chi_square'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Distributions::ChiSquare do
  subject { StatisticCalcs::Distributions::ChiSquare.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { v: 49, x: 56 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(56)
      expect(subject.f_x).to eq(0.77115)
      expect(subject.g_x).to eq(0.22885)
      expect(subject.mean).to eq(49.0)
      expect(subject.variance).to eq(98.0)
      expect(subject.standard_deviation).to eq(9.89949)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { v: 49, f_x: 0.77115 } }

    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(56)
      expect(subject.f_x).to eq(0.77115)
      expect(subject.g_x).to eq(0.22885)
      expect(subject.mean).to eq(49.0)
      expect(subject.variance).to eq(98.0)
      expect(subject.standard_deviation).to eq(9.89949)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { v: 49, g_x: 0.22885 } }

    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(56)
      expect(subject.f_x).to eq(0.77115)
      expect(subject.g_x).to eq(0.22885)
      expect(subject.mean).to eq(49.0)
      expect(subject.variance).to eq(98.0)
      expect(subject.standard_deviation).to eq(9.89949)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { v: 149, x: 156 } }

    it 'should fill all the attributes' do
      expect(subject.x).to eq(156)
      expect(subject.f_x).to eq(0.66923)
      expect(subject.g_x).to eq(0.33077)
      expect(subject.mean).to eq(149.0)
      expect(subject.variance).to eq(298.0)
      expect(subject.standard_deviation).to eq(17.26268)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { v: 149, f_x: 0.66923 } }

    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(156)
      expect(subject.f_x).to eq(0.66923)
      expect(subject.g_x).to eq(0.33077)
      expect(subject.mean).to eq(149.0)
      expect(subject.variance).to eq(298.0)
      expect(subject.standard_deviation).to eq(17.26268)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { v: 149, g_x: 0.33077 } }

    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(156)
      expect(subject.f_x).to eq(0.66923)
      expect(subject.g_x).to eq(0.33077)
      expect(subject.mean).to eq(149.0)
      expect(subject.variance).to eq(298.0)
      expect(subject.standard_deviation).to eq(17.26268)
    end
  end
end
# rubocop:enable BlockLength
