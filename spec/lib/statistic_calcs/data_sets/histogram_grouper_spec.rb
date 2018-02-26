# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/data_sets/data_set_spec.rb
require 'statistic_calcs/data_sets/data_set'

require 'pry'
# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::DataSets::HistogramGrouper do
  subject { StatisticCalcs::DataSets::DataSet.new(x_values: x_values) }

  describe '.mean' do
    context 'valid scenarios' do
      let(:x_values) { [738, 600, 920, 1000, 897, 999, 601, 602] }
      context 'give the histograms' do
        before do
          subject.split_in(4)
        end

        it 'generate the histogram' do
          expect(subject.intervals).to eq(4)
          expect(subject.range).to eq(100)
          expect(subject.histogram_keys).to eq(['less_than_700.0', '700.0..800.0', '800.0..900.0', '900.0_or_more_than'])
          expect(subject.adjusted_keys).to eq(['600.0..700.0', '700.0..800.0', '800.0..900.0', '900.0..1000.0'])
          expect(subject.histogram_values).to eq([3, 1, 1, 3])
          expect(subject.grouped_values).to eq([[600, 601, 602], [738], [897], [920, 1000, 999]])
          expect(subject.histogram_values_mid_points).to eq([650.0, 750.0, 850.0, 950.0])
          expect(subject.grouped_values_hash).to eq('less_than_700.0' => [600, 601, 602], '700.0..800.0' => [738], '800.0..900.0' => [897], '900.0_or_more_than' => [920, 1000, 999])
        end
      end

      context 'give the histograms' do
        before do
          subject.group_each(100)
        end

        it 'generate the histogram' do
          expect(subject.intervals).to eq(4)
          expect(subject.range).to eq(100)
          expect(subject.histogram_keys).to eq(['less_than_700.0', '700.0..800.0', '800.0..900.0', '900.0_or_more_than'])
          expect(subject.adjusted_keys).to eq(['600.0..700.0', '700.0..800.0', '800.0..900.0', '900.0..1000.0'])
          expect(subject.histogram_values_mid_points).to eq([650.0, 750.0, 850.0, 950.0])
          expect(subject.histogram_values).to eq([3, 1, 1, 3])
          expect(subject.grouped_values).to eq([[600, 601, 602], [738], [897], [920, 1000, 999]])
          expect(subject.grouped_values_hash).to eq('less_than_700.0' => [600, 601, 602], '700.0..800.0' => [738], '800.0..900.0' => [897], '900.0_or_more_than' => [920, 1000, 999])
        end
      end
    end

    context 'valid scenario 2' do
      let(:x_values) do
        [
          600, 1000, 985, 998, 692, 973, 631, 814, 739, 733, 838, 813, 731, 801, 913, 754, 778, 697, 646,
          649, 759, 909, 671, 801, 995, 677, 719, 960, 713, 881, 900, 981, 608, 909, 998, 877, 785, 681,
          897, 679, 965, 948, 684, 766, 989, 878, 807, 672, 741, 670, 752, 818, 766, 759, 866, 650, 941, 819, 756, 635
        ]
      end
      context 'give the histograms' do
        before do
          subject.split_in(20)
        end

        it 'generate the histogram' do
          expect(subject.intervals).to eq(20)
          expect(subject.range).to eq(20)
          expect(subject.histogram_keys).to eq(
            [
              'less_than_620.0', '620.0..640.0', '640.0..660.0', '660.0..680.0', '680.0..700.0',
              '700.0..720.0', '720.0..740.0', '740.0..760.0', '760.0..780.0', '780.0..800.0',
              '800.0..820.0', '820.0..840.0', '840.0..860.0', '860.0..880.0', '880.0..900.0',
              '900.0..920.0', '920.0..940.0', '940.0..960.0', '960.0..980.0', '980.0_or_more_than'
            ]
          )
          expect(subject.adjusted_keys).to eq(
            [
              '600.0..620.0', '620.0..640.0', '640.0..660.0', '660.0..680.0', '680.0..700.0', '700.0..720.0',
              '720.0..740.0', '740.0..760.0', '760.0..780.0', '780.0..800.0', '800.0..820.0', '820.0..840.0',
              '840.0..860.0', '860.0..880.0', '880.0..900.0', '900.0..920.0', '920.0..940.0', '940.0..960.0',
              '960.0..980.0', '980.0..1000.0'
            ]
          )

          expect(subject.grouped_values_hash).to eq(
            'less_than_620.0' => [600, 608],
            '620.0..640.0' => [631, 635],
            '640.0..660.0' => [646, 649, 650],
            '660.0..680.0' => [671, 677, 679, 672, 670],
            '680.0..700.0' => [692, 697, 681, 684],
            '700.0..720.0' => [719, 713],
            '720.0..740.0' => [739, 733, 731],
            '740.0..760.0' => [754, 759, 741, 752, 759, 756],
            '760.0..780.0' => [778, 766, 766],
            '780.0..800.0' => [785],
            '800.0..820.0' => [814, 813, 801, 801, 807, 818, 819],
            '820.0..840.0' => [838],
            '840.0..860.0' => [],
            '860.0..880.0' => [877, 878, 866],
            '880.0..900.0' => [881, 897],
            '900.0..920.0' => [913, 909, 900, 909],
            '920.0..940.0' => [],
            '940.0..960.0' => [948, 941],
            '960.0..980.0' => [973, 960, 965],
            '980.0_or_more_than' => [1000, 985, 998, 995, 981, 998, 989]
          )
          expect([2, 2, 3, 5, 4, 2, 3, 6, 3, 1, 7, 1, 0, 3, 2, 4, 0, 2, 3, 7])
        end
      end
    end
  end
end
# rubocop:enable BlockLength
