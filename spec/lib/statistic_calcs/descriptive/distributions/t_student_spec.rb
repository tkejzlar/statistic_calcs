# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/descriptive/distributions/t_student_spec.rb
require 'statistic_calcs/descriptive/distributions/t_student.rb'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::Descriptive::Distributions::TStudent do
  subject { StatisticCalcs::Descriptive::Distributions::TStudent.new(options) }

  before { subject.calc! }
  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { degrees_of_freedom: 45, x: 1.33 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.33)
      expect(subject.f_x).to eq(0.90489)
      expect(subject.g_x).to eq(0.09511)
      expect(subject.mean).to eq(0)
      expect(subject.variance).to eq(1.04651)
      expect(subject.standard_deviation).to eq(1.02299)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { degrees_of_freedom: 45, f_x: 0.90489 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.33)
      expect(subject.f_x).to eq(0.90489)
      expect(subject.g_x).to eq(0.09511)
      expect(subject.mean).to eq(0)
      expect(subject.variance).to eq(1.04651)
      expect(subject.standard_deviation).to eq(1.02299)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { degrees_of_freedom: 45, g_x: 0.09511 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(1.33)
      expect(subject.f_x).to eq(0.90489)
      expect(subject.g_x).to eq(0.09511)
      expect(subject.mean).to eq(0)
      expect(subject.variance).to eq(1.04651)
      expect(subject.standard_deviation).to eq(1.02299)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { degrees_of_freedom: 1.99, x: 0.44 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.44)
      expect(subject.f_x).to eq(0.64845)
      expect(subject.g_x).to eq(0.35155)
      expect(subject.mean).to eq(0)
      expect(subject.variance).to eq(Float::INFINITY)
      expect(subject.standard_deviation).to eq(Float::INFINITY)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { degrees_of_freedom: 1.99, f_x: 0.64845 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.44002)
      expect(subject.f_x).to eq(0.64845)
      expect(subject.g_x).to eq(0.35155)
      expect(subject.mean).to eq(0)
      expect(subject.variance).to eq(Float::INFINITY)
      expect(subject.standard_deviation).to eq(Float::INFINITY)
    end
  end

  describe 'calc to get f(x), p(x) & g(x)' do
    let(:options) { { degrees_of_freedom: 1.99, g_x: 0.35155 } }
    it 'should fill all the attributes' do
      expect(subject.x).to eq(0.44002)
      expect(subject.f_x).to eq(0.64845)
      expect(subject.g_x).to eq(0.35155)
      expect(subject.mean).to eq(0)
      expect(subject.variance).to eq(Float::INFINITY)
      expect(subject.standard_deviation).to eq(Float::INFINITY)
    end
  end
end
# rubocop:enable BlockLength
