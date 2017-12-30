# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/gumbel_maximum_spec.rb
require 'statistic_calcs/descriptive/distributions/gumbel_maximum.rb'
require 'spec_helper'

RSpec.describe StatisticCalcs::Descriptive::Distributions::GumbelMaximum do
  subject { StatisticCalcs::Descriptive::Distributions::GumbelMaximum.new(options) }

  # TODO: Implement before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { thita: 2, beta: 3, x: 1 } }

    it 'should fill all the attributes' do
      # expect(subject.g_x).to eq(0.2477)
      # expect(subject.f_x).to eq(0.36473)
      # expect(subject.mean).to eq(22.22222)
      # expect(subject.variance).to eq(2.46914)
      # expect(subject.standard_deviation).to eq(1.57135)
    end
  end
end
