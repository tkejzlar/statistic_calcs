# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/pascal_spec.rb
require 'statistic_calcs/descriptive/distributions/pascal.rb'

RSpec.describe StatisticCalcs::Descriptive::Distributions::Pascal do
  subject { StatisticCalcs::Descriptive::Distributions::Pascal.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { n: 21, r: 20, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(21)
      expect(subject.r).to eq(20)
      expect(subject.p).to eq(0.9)

      expect(subject.p_x).to eq(0.24315)
      expect(subject.g_x).to eq(0.87842)
      expect(subject.f_x).to eq(0.36473)
      expect(subject.mean).to eq(22.22222)
      expect(subject.variance).to eq(2.46914)
      expect(subject.standard_deviation).to eq(1.57135)
    end
  end
end
