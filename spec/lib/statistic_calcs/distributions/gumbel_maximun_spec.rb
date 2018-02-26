# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/distributions/gumbel_maximum_spec.rb
require 'statistic_calcs/distributions/gumbel_maximum'

RSpec.describe StatisticCalcs::Distributions::GumbelMaximum do
  subject { StatisticCalcs::Distributions::GumbelMaximum.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { thita: 2, beta: 3, x: 1 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.24768)
      expect(subject.g_x).to eq(0.75232)
      expect(subject.mean).to eq(3.73165)
      expect(subject.variance).to eq(14.80441)
      expect(subject.standard_deviation).to eq(3.84765)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { location: 2, scale: 3, x: 1 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.24768)
      expect(subject.g_x).to eq(0.75232)
      expect(subject.mean).to eq(3.73165)
      expect(subject.variance).to eq(14.80441)
      expect(subject.standard_deviation).to eq(3.84765)
    end
  end
end
