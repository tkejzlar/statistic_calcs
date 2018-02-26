# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/hypothesis_test/uniform_goodness_and_fit_spec.rb
require 'statistic_calcs/hypothesis_test/goodness_and_fit'
require 'statistic_calcs/chi_square_contrast/uniform_goodness_and_fit'
require 'statistic_calcs/hypothesis_test/cases'
require 'pry'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::HypothesisTest::GoodnessAndFit do
  subject { StatisticCalcs::HypothesisTest::GoodnessAndFit.new(data: data) }
  let!(:data) do
    StatisticCalcs::ChiSquareContrast::UniformGoodnessAndFit.new(
      data_set: [
        600, 1000, 985, 998, 692, 973, 631, 814, 739, 733, 838, 813, 731, 801, 913, 754, 778, 697, 646,
        649, 759, 909, 671, 801, 995, 677, 719, 960, 713, 881, 900, 981, 608, 909, 998, 877, 785, 681,
        897, 679, 965, 948, 684, 766, 989, 878, 807, 672, 741, 670, 752, 818, 766, 759, 866, 650, 941, 819, 756, 635
      ]
    )
  end

  context 'Happy path' do
    before { subject.calc! }
    describe 'Chi square contrast test' do
      it 'should fill all the attributes' do
        expect(subject.null_hypothesis).to eq('Xc^2 <= X^2(1 - alpha, V). 26.0 <= 30.14353')
        expect(subject.alternative_hypothesis).to eq('Xc^2 > X^2')
        expect(subject.critical_fractil).to eq(26.0)
        expect(subject.reject).to eq(false)
        expect(subject.reject_condition).to eq('Xc^2 > X^2 -> reject H0. `26.0 > 30.14` -> false')
      end
    end
  end

  context 'Errors' do
    describe 'raise validation error' do
      subject { StatisticCalcs::HypothesisTest::GoodnessAndFit.new(options) }
      let(:options) { { alpha: 1.05 } }
      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, 'alpha/confidence_level should be between 0 and 1')
      end
    end

    describe 'raise validation error' do
      let!(:data) {}
      let(:options) { { alpha: 0.95 } }
      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, '`data` is required')
      end
    end

    describe 'raise validation error' do
      let!(:data) { [1, 2] }
      let(:options) { { alpha: 0.95 } }
      it 'should fill all the attributes' do
        expect { subject.calc! }.to raise_error(StandardError, '`data` should be a `StatisticCalcs::ChiSquareContrast::GoodnessAndFit` object')
      end
    end
  end
end
# rubocop:enable BlockLength
