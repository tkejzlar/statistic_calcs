# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/exponential_spec.rb
require 'statistic_calcs/descriptive/distributions/exponential.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Exponential do
  subject { StatisticCalcs::Descriptive::Distributions::Exponential.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { lambda: 45, x: 0.0698 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.0698)
      expect(subject.f_x).to eq(0.95676)
      expect(subject.g_x).to eq(0.04324)
      expect(subject.mean).to eq(0.02222)
      expect(subject.variance).to eq(0.00049)
      expect(subject.standard_deviation).to eq(0.02222)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { lambda: 45, f_x: 0.95676 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.0698)
      expect(subject.f_x).to eq(0.95676)
      expect(subject.g_x).to eq(0.04324)
      expect(subject.mean).to eq(0.02222)
      expect(subject.variance).to eq(0.00049)
      expect(subject.standard_deviation).to eq(0.02222)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { lambda: 45, g_x: 0.04324 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.0698)
      expect(subject.f_x).to eq(0.95676)
      expect(subject.g_x).to eq(0.04324)
      expect(subject.mean).to eq(0.02222)
      expect(subject.variance).to eq(0.00049)
      expect(subject.standard_deviation).to eq(0.02222)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { lambda: 2, x: 0.1 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.1)
      expect(subject.f_x).to eq(0.18127)
      expect(subject.g_x).to eq(0.81873)
      expect(subject.mean).to eq(0.5)
      expect(subject.variance).to eq(0.25)
      expect(subject.standard_deviation).to eq(0.5)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { lambda: 2, f_x: 0.18127 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.1)
      expect(subject.f_x).to eq(0.18127)
      expect(subject.g_x).to eq(0.81873)
      expect(subject.mean).to eq(0.5)
      expect(subject.variance).to eq(0.25)
      expect(subject.standard_deviation).to eq(0.5)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { lambda: 2, g_x: 0.81873 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.1)
      expect(subject.f_x).to eq(0.18127)
      expect(subject.g_x).to eq(0.81873)
      expect(subject.mean).to eq(0.5)
      expect(subject.variance).to eq(0.25)
      expect(subject.standard_deviation).to eq(0.5)
    end
  end
end
# rubocop:enable BlockLength
