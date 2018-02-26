# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/data_sets/grouped_data_spec.rb
require 'statistic_calcs/data_sets/grouped_data_set'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::DataSets::GroupedDataSet do
  context 'with values' do
    let(:x_values) { [1.2, 2.3, 3.4, 1] }
    let(:lower_class_boundary_values) { [1.2, 4.3, 9.4, 14.5] }
    let(:upper_class_boundary_values) { [4.3, 9.4, 14.5, 19.6] }
    subject do
      StatisticCalcs::DataSets::GroupedDataSet.new(
        x_values: x_values,
        lower_class_boundary_values: lower_class_boundary_values,
        upper_class_boundary_values: upper_class_boundary_values
      )
    end
    before { subject.calc! }

    context 'give the average of the list' do
      it 'return' do
        expect(subject.lower_class_boundary_values).to eq([1.2, 4.3, 9.4, 14.5])
        expect(subject.upper_class_boundary_values).to eq([4.3, 9.4, 14.5, 19.6])
        expect(subject.mid_points).to eq([2.75, 6.85, 11.95, 17.05])
        expect(subject.mean).to eq(2.75)
        expect(subject.n).to eq(4)
        expect(subject.standard_deviation).to eq(0)
        expect(subject.variance).to eq(0)
        expect(subject.sum).to eq(7.9)
        expect(subject.min).to eq(1)
        expect(subject.max).to eq(3.4)
      end
    end
  end

  context 'with values' do
    let(:x_values) { [620, 730, 740, 801, 900, 1000, 999] }
    let(:class_boundary_values_values) { ['600..700.0', '700.0..800.0', '800.0..900.0', '900.0..1000'] }
    subject do
      StatisticCalcs::DataSets::GroupedDataSet.new(
        x_values: x_values,
        class_boundary_values_values: class_boundary_values_values
      )
    end
    before { subject.calc! }

    context 'give the average of the list' do
      it 'return' do
        expect(subject.n).to eq(7)
        expect(subject.lower_class_boundary_values).to eq([600.0, 700.0, 800.0, 900.0])
        expect(subject.upper_class_boundary_values).to eq([700.0, 800.0, 900.0, 1000.0])
        expect(subject.mid_points).to eq([650.0, 750.0, 850.0, 950.0])
        expect(subject.range).to eq(100)
        expect(subject.intervals).to eq(4)
        expect(subject.frequency).to eq([1, 2, 1, 3])
        expect(subject.mean).to eq(835.7142857142857)
        expect(subject.variance).to eq(14_761.904761904763)
        expect(subject.standard_deviation).to eq(121.49857925879118)
        expect(subject.sum).to eq(5_790)
        expect(subject.min).to eq(620)
        expect(subject.max).to eq(1_000)
      end
    end
  end

  context 'without values' do
    let(:x_values) { [] }
    context 'give the average of the list' do
      it 'return nil' do
        expect(subject.mean).to be(0)
      end
    end
  end
end
# rubocop:enable BlockLength
