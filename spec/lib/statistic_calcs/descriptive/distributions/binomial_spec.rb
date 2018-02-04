# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/binomial_spec.rb
require 'statistic_calcs/descriptive/distributions/binomial.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::Binomial do
  subject { StatisticCalcs::Descriptive::Distributions::Binomial.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { n: 20, r: 19, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(19) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.27017) # probability_x
      expect(subject.f_x).to eq(0.87842) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.39175) # cumulative_greater_than_x_probability
      expect(subject.mean).to eq(18.0)
      expect(subject.median).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { n: 78, r: 55, p: 0.7623 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(78) # number_trials
      expect(subject.r).to eq(55) # number_successes
      expect(subject.p).to eq(0.7623) # probability_of_success
      expect(subject.p_x).to eq(0.05052) # probability_x
      expect(subject.f_x).to eq(0.14646) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.90406) # cumulative_greater_than_x_probability
      expect(subject.mean).to eq(59.45940)
      expect(subject.variance).to eq(14.13350)
      expect(subject.standard_deviation).to eq(3.75945)
      expect(subject.skewness).to eq(-0.03712)
      expect(subject.kurtosis).to eq(2.99383)
      expect(subject.coefficient_variation).to eq(14.1335)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { n: 200, r: 60, p: 0.25 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(200) # number_trials
      expect(subject.r).to eq(60) # number_successes
      expect(subject.p).to eq(0.25) # probability_of_success
      expect(subject.p_x).to eq(0.01708) # probability_x
      expect(subject.f_x).to eq(0.95461) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.06247) # cumulative_greater_than_x_probability
      expect(subject.mean).to eq(50)
      expect(subject.variance).to eq(37.5)
      expect(subject.standard_deviation).to eq(6.12372)
      expect(subject.skewness).to eq(0.01333)
      expect(subject.kurtosis).to eq(2.99667)
      expect(subject.coefficient_variation).to eq(37.5)
    end
  end

  describe 'calc to get r with f_x' do
    let(:options) { { n: 20, f_x: 0.87842, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(18) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.28518) # probability_x
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get r with f_x 0' do
    let(:options) { { n: 20, f_x: 0.0, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(0) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0) # probability_x
      expect(subject.f_x).to eq(0) # cumulative_less_than_x_probability
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get r with g_x' do
    let(:options) { { n: 20, g_x: 0.87842, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(16) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.08978) # probability_x
      expect(subject.f_x).to eq(0.13295) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.95683) # cumulative_greater_than_x_probability
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get r with g_x 0' do
    let(:options) { { n: 20, g_x: 0.0, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(20) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.12158) # probability_x
      expect(subject.f_x).to eq(1) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.12158) # cumulative_greater_than_x_probability
      expect(subject.mean).to eq(18.0)
      expect(subject.variance).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get p with f_x' do
    let(:options) { { n: 20, r: 19, f_x: 0.87842 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(19) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.27018) # probability_x
      expect(subject.f_x).to eq(0.87842) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.39176) # cumulative_greater_than_x_probability
      expect(subject.mean.round(2)).to eq(18.0)
      expect(subject.variance.round(2)).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34163)
      expect(subject.skewness).to eq(-0.44445)
      expect(subject.kurtosis).to eq(3.25557)
      expect(subject.coefficient_variation).to eq(1.79997)
    end
  end

  describe 'calc to get n with mean and p' do
    let(:options) { { mean: 18.0, r: 19, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(19) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.27017) # probability_x
      expect(subject.f_x).to eq(0.87842) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.39175) # cumulative_greater_than_x_probability
      expect(subject.mean.round(2)).to eq(18.0)
      expect(subject.variance.round(2)).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get n with standard deviation & p' do
    let(:options) { { standard_deviation: 1.34164, r: 19, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(19) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.27017) # probability_x
      expect(subject.f_x).to eq(0.87842) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.39175) # cumulative_greater_than_x_probability
      expect(subject.mean.round(2)).to eq(18.0)
      expect(subject.variance.round(2)).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end

  describe 'calc to get n with variance & p' do
    let(:options) { { variance: 1.8, r: 19, p: 0.9 } }

    it 'should fill all the attributes' do
      expect(subject.n).to eq(20) # number_trials
      expect(subject.r).to eq(19) # number_successes
      expect(subject.p).to eq(0.9) # probability_of_success
      expect(subject.p_x).to eq(0.27017) # probability_x
      expect(subject.f_x).to eq(0.87842) # cumulative_less_than_x_probability
      expect(subject.g_x).to eq(0.39175) # cumulative_greater_than_x_probability
      expect(subject.mean.round(2)).to eq(18.0)
      expect(subject.variance.round(2)).to eq(1.8)
      expect(subject.standard_deviation).to eq(1.34164)
      expect(subject.skewness).to eq(-0.44444)
      expect(subject.kurtosis).to eq(3.25556)
      expect(subject.coefficient_variation).to eq(1.8)
    end
  end
end
# rubocop:enable BlockLength
