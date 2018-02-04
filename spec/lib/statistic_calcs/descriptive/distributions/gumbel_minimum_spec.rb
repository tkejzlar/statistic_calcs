# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/gumbel_minimum_spec.rb
require 'statistic_calcs/descriptive/distributions/gumbel_minimum.rb'

RSpec.describe StatisticCalcs::Descriptive::Distributions::GumbelMinimum do
  subject { StatisticCalcs::Descriptive::Distributions::GumbelMinimum.new(options) }

  # TODO: not implemented
  # before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    # let(:options) { {  } }

    it 'should fill all the attributes' do
      # expect(subject.g_x).to eq(0.87842)
      # expect(subject.f_x).to eq(0.36473)
      # expect(subject.mean).to eq(22.22222)
      # expect(subject.variance).to eq(2.46914)
      # expect(subject.standard_deviation).to eq(1.57135)
    end
  end
end
