# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/chi_square_spec.rb
require 'statistic_calcs/descriptive/distributions/chi_square.rb'
require 'spec_helper'

RSpec.describe StatisticCalcs::Descriptive::Distributions::ChiSquare do
  subject { StatisticCalcs::Descriptive::Distributions::ChiSquare.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { v: 49, x: 56 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.77115)
      expect(subject.g_x).to eq(0.22885)
      expect(subject.mean).to eq(49.0)
      expect(subject.variance).to eq(98.0)
      expect(subject.standard_deviation).to eq(9.89949)
    end
  end

  describe 'calc to get f, p & g' do
    let(:options) { { v: 149, x: 156 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.66923)
      expect(subject.g_x).to eq(0.33077)
      expect(subject.mean).to eq(149.0)
      expect(subject.variance).to eq(298.0)
      expect(subject.standard_deviation).to eq(17.26268)
    end
  end
end
