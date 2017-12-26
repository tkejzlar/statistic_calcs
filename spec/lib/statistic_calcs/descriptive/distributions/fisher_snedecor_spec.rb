# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/fisher_snedecor_spec.rb
require 'statistic_calcs/descriptive/distributions/fisher_snedecor.rb'
require 'spec_helper'

RSpec.describe StatisticCalcs::Descriptive::Distributions::FisherSnedecor do
  subject { StatisticCalcs::Descriptive::Distributions::FisherSnedecor.new(options) }

  before { subject.calc! }
  describe 'calc to get f, p & g' do
    let(:options) { { d1: 45, d2: 36, x: 1.23 } }

    it 'should fill all the attributes' do
      expect(subject.f_x).to eq(0.73754)
      expect(subject.g_x).to eq(0.26246)
      expect(subject.mean).to eq(1.05882)
      expect(subject.variance).to eq(0.12301)
      expect(subject.standard_deviation).to eq(0.35073)
    end
    describe 'calc to get f, p & g' do
      let(:options) { { d1: 3, d2: 44, x: 1.569 } }

      it 'should fill all the attributes' do
        expect(subject.f_x).to eq(0.78964)
        expect(subject.g_x).to eq(0.21036)
        expect(subject.mean).to eq(1.04762)
        expect(subject.variance).to eq(0.82313)
        expect(subject.standard_deviation).to eq(0.90726)
      end
    end
  end
end
