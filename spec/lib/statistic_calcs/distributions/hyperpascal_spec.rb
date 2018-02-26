# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/distributions/Hyperpascal_spec.rb
require 'statistic_calcs/distributions/hyperpascal'

RSpec.describe StatisticCalcs::Distributions::Hyperpascal do
  subject { StatisticCalcs::Distributions::Hyperpascal.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { n: 25, population_size: 36, total_number_successes: 34, x: 24 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(25)
      expect(subject.population_size).to eq(36)
      expect(subject.total_number_successes).to eq(34)
      expect(subject.x).to eq(24)
      # TODO: check and finish
    end
  end
end
