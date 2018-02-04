# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/geometric_spec.rb
require 'statistic_calcs/descriptive/distributions/geometric.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Geometric do
  subject { StatisticCalcs::Descriptive::Distributions::Geometric.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { r: 2, p: 0.235 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(2)
      expect(subject.p).to eq(0.235)
      expect(subject.p_x).to eq(0.13753)
      expect(subject.f_x).to eq(0.55230)
      expect(subject.g_x).to eq(0.58523)
      expect(subject.mean).to eq(3.25532)
      expect(subject.variance).to eq(13.85242)
      expect(subject.standard_deviation).to eq(3.72188)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { r: 1, p: 0.7623 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(1)
      expect(subject.p).to eq(0.7623)
      expect(subject.p_x).to eq(0.18120)
      expect(subject.f_x).to eq(0.94350)
      expect(subject.g_x).to eq(0.23770)
      expect(subject.mean).to eq(0.31182)
      expect(subject.variance).to eq(0.40905)
      expect(subject.standard_deviation).to eq(0.63957)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { r: 10, p: 0.25 } }

    it 'should fill all the attributes' do
      expect(subject.r).to eq(10)
      expect(subject.p).to eq(0.25)
      expect(subject.p_x).to eq(0.01408)
      expect(subject.f_x).to eq(0.95776)
      expect(subject.g_x).to eq(0.05631)
      expect(subject.mean).to eq(3.0)
      expect(subject.variance).to eq(12.0)
      expect(subject.standard_deviation).to eq(3.46410)
    end
  end
end
# rubocop:enable BlockLength
