# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/distributions/log_normal_spec.rb
require 'statistic_calcs/distributions/log_normal'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Distributions::LogNormal do
  subject { StatisticCalcs::Distributions::LogNormal.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { zeta: 4, sigma: 3, x: 78 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(78)
      expect(subject.f_x).to eq(0.54732)
      expect(subject.g_x).to eq(0.45268)
      expect(subject.mean).to eq(4914.76884)
      expect(subject.variance).to eq(195_705_454_476.08487)
      expect(subject.standard_deviation).to eq(442_386.09209)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { zeta: 4, sigma: 3, f_x: 0.54732 } }
    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(78)
      expect(subject.f_x).to eq(0.54732)
      expect(subject.g_x).to eq(0.45268)
      expect(subject.mean).to eq(4914.76884)
      expect(subject.variance).to eq(195_705_454_476.08487)
      expect(subject.standard_deviation).to eq(442_386.09209)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { zeta: 4, sigma: 3, g_x: 0.45268 } }
    it 'should fill all the attributes' do
      expect(subject.x.round).to eq(78)
      expect(subject.f_x).to eq(0.54732)
      expect(subject.g_x).to eq(0.45268)
      expect(subject.mean).to eq(4914.76884)
      expect(subject.variance).to eq(195_705_454_476.08487)
      expect(subject.standard_deviation).to eq(442_386.09209)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { zeta: 0.554, sigma: 1, x: 3.2 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(3.2)
      expect(subject.f_x).to eq(0.72879)
      expect(subject.g_x).to eq(0.27121)
      expect(subject.mean).to eq(2.86910)
      expect(subject.variance).to eq(14.14449)
      expect(subject.standard_deviation).to eq(3.76092)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { zeta: 0.554, sigma: 1, f_x: 0.72879 } }
    it 'should fill all the attributes' do
      expect(subject.x.round(1)).to eq(3.2)
      expect(subject.f_x).to eq(0.72879)
      expect(subject.g_x).to eq(0.27121)
      expect(subject.mean).to eq(2.86910)
      expect(subject.variance).to eq(14.14449)
      expect(subject.standard_deviation).to eq(3.76092)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { zeta: 0.554, sigma: 1, g_x: 0.27121 } }
    it 'should fill all the attributes' do
      expect(subject.x.round(1)).to eq(3.2)
      expect(subject.f_x).to eq(0.72879)
      expect(subject.g_x).to eq(0.27121)
      expect(subject.mean).to eq(2.86910)
      expect(subject.variance).to eq(14.14449)
      expect(subject.standard_deviation).to eq(3.76092)
    end
  end
end
# rubocop:enable BlockLength
