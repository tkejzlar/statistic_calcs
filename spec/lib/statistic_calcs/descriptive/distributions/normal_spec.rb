# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/normal_spec.rb
require 'statistic_calcs/descriptive/distributions/normal.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Normal do
  subject { StatisticCalcs::Descriptive::Distributions::Normal.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 0, standard_deviation: 1, x: 1.64489 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.64489)
      expect(subject.f_x).to eq(0.95)
      expect(subject.g_x).to eq(0.05)
      expect(subject.sigma).to eq(1)
      expect(subject.standard_deviation).to eq(1)
      expect(subject.mean).to eq(0)
    end
  end

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 0, standard_deviation: 1, f_x: 0.95 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.64485)
      expect(subject.f_x).to eq(0.95)
      expect(subject.g_x).to eq(0.05)
      expect(subject.sigma).to eq(1)
      expect(subject.standard_deviation).to eq(1)
      expect(subject.mean).to eq(0)
    end
  end

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 0, standard_deviation: 1, g_x: 0.05 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.64485)
      expect(subject.f_x).to eq(0.95)
      expect(subject.g_x).to eq(0.05)
      expect(subject.sigma).to eq(1)
      expect(subject.standard_deviation).to eq(1)
      expect(subject.mean).to eq(0)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 0, standard_deviation: 1, x: 1.44 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.44)
      expect(subject.f_x).to eq(0.92507)
      expect(subject.g_x).to eq(0.07493)
      expect(subject.sigma).to eq(1)
      expect(subject.standard_deviation).to eq(1)
      expect(subject.mean).to eq(0)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 0, standard_deviation: 1, f_x: 0.92507 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.44003)
      expect(subject.f_x).to eq(0.92507)
      expect(subject.g_x).to eq(0.07493)
      expect(subject.sigma).to eq(1)
      expect(subject.standard_deviation).to eq(1)
      expect(subject.mean).to eq(0)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 0, standard_deviation: 1, g_x: 0.07493 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.44003)
      expect(subject.f_x).to eq(0.92507)
      expect(subject.g_x).to eq(0.07493)
      expect(subject.sigma).to eq(1)
      expect(subject.standard_deviation).to eq(1)
      expect(subject.mean).to eq(0)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 47.9, standard_deviation: 1.33, x: 46.779 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(46.779)
      expect(subject.f_x).to eq(0.19965)
      expect(subject.g_x).to eq(0.80035)
      expect(subject.sigma).to eq(1.76890)
      expect(subject.standard_deviation).to eq(1.33)
      expect(subject.mean).to eq(47.9)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 47.9, standard_deviation: 1.33, f_x: 0.19965 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(46.77898)
      expect(subject.f_x).to eq(0.19965)
      expect(subject.g_x).to eq(0.80035)
      expect(subject.sigma).to eq(1.76890)
      expect(subject.standard_deviation).to eq(1.33)
      expect(subject.mean).to eq(47.9)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: 47.9, standard_deviation: 1.33, g_x: 0.80035 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(46.77898)
      expect(subject.f_x).to eq(0.19965)
      expect(subject.g_x).to eq(0.80035)
      expect(subject.sigma).to eq(1.76890)
      expect(subject.standard_deviation).to eq(1.33)
      expect(subject.mean).to eq(47.9)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: -6.4469, standard_deviation: 0.05, x: -6.556 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(-6.556)
      expect(subject.f_x).to eq(0.01455)
      expect(subject.g_x).to eq(0.98545)
      expect(subject.sigma).to eq(0.0025)
      expect(subject.standard_deviation).to eq(0.05)
      expect(subject.mean).to eq(-6.4469)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: -6.4469, standard_deviation: 0.05, f_x: 0.01455 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(-6.55601)
      expect(subject.f_x).to eq(0.01455)
      expect(subject.g_x).to eq(0.98545)
      expect(subject.sigma).to eq(0.0025)
      expect(subject.standard_deviation).to eq(0.05)
      expect(subject.mean).to eq(-6.4469)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { mean: -6.4469, standard_deviation: 0.05, g_x: 0.98545 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(-6.55601)
      expect(subject.f_x).to eq(0.01455)
      expect(subject.g_x).to eq(0.98545)
      expect(subject.sigma).to eq(0.0025)
      expect(subject.standard_deviation).to eq(0.05)
      expect(subject.mean).to eq(-6.4469)
    end
  end
end
# rubocop:enable BlockLength
