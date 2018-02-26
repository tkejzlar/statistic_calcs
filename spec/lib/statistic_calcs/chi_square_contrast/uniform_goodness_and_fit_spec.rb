# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/chi_square_contrast/uniform_goodness_and_fit_spec.rb
require 'statistic_calcs/chi_square_contrast/uniform_goodness_and_fit'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::ChiSquareContrast::UniformGoodnessAndFit do
  subject { StatisticCalcs::ChiSquareContrast::UniformGoodnessAndFit.new(data_set: values) }

  describe 'test if the list of values apply to a uniform law' do
    context 'valid scenarios' do
      let(:values) do
        [
          600, 1000, 985, 998, 692, 973, 631, 814, 739, 733, 838, 813, 731, 801, 913, 754, 778, 697, 646,
          649, 759, 909, 671, 801, 995, 677, 719, 960, 713, 881, 900, 981, 608, 909, 998, 877, 785, 681,
          897, 679, 965, 948, 684, 766, 989, 878, 807, 672, 741, 670, 752, 818, 766, 759, 866, 650, 941, 819, 756, 635
        ]
      end
      context 'calculate' do
        before do
          subject.calc!
        end

        it 'generate the goodness and fit tables and values' do
          expect(subject.cluster_mid_points).to eq([610.0, 630.0, 650.0, 670.0, 690.0, 710.0, 730.0, 750.0, 770.0, 790.0, 810.0, 830.0, 850.0, 870.0, 890.0, 910.0, 930.0, 950.0, 970.0, 990.0])
          expect(subject.observed_frequencies).to eq([2, 2, 3, 5, 4, 2, 3, 6, 3, 1, 7, 1, 0, 3, 2, 4, 0, 2, 3, 7])
          expect(subject.occurrence_probabilities).to eq([0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05])
          expect(subject.expected_frequencies).to eq([3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3])
          expect(subject.critical_chi_square).to eq(26)
        end
      end
    end

    context 'valid scenarios 2' do
      subject { StatisticCalcs::ChiSquareContrast::UniformGoodnessAndFit.new(data_set: values, clusters_count: 4) }
      let(:values) do
        [
          600, 1000, 985, 998, 692, 973, 631, 814, 739, 733, 838, 813, 731, 801, 913, 754, 778, 697, 646,
          649, 759, 909, 671, 801, 995, 677, 719, 960, 713, 881, 900, 981, 608, 909, 998, 877, 785, 681,
          897, 679, 965, 948, 684, 766, 989, 878, 807, 672, 741, 670, 752, 818, 766, 759, 866, 650, 941, 819, 756, 635
        ]
      end
      context 'calculate' do
        before do
          subject.calc!
        end

        it 'generate the goodness and fit tables and values' do
          expect(subject.cluster_keys).to eq(['less_than_700.0', '700.0..800.0', '800.0..900.0', '900.0_or_more_than'])
          expect(subject.cluster_values).to eq(['600.0..700.0', '700.0..800.0', '800.0..900.0', '900.0..1000.0'])
          expect(subject.cluster_mid_points).to eq([650.0, 750.0, 850.0, 950.0])
          expect(subject.observed_frequencies).to eq([16, 15, 13, 16])
          expect(subject.occurrence_probabilities).to eq([0.25, 0.25, 0.25, 0.25])
          expect(subject.expected_frequencies).to eq([15, 15, 15, 15])
          expect(subject.critical_chi_square).to eq(0.4)
        end
      end
    end
  end
end
# rubocop:enable BlockLength
