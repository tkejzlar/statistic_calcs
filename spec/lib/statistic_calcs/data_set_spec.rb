# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/data_set_spec.rb
require 'statistic_calcs/data_set'
require 'statistic_calcs/grouped_data_set'

# rubocop:disable BlockLength
RSpec.describe StatisticCalcs::DataSet do
  subject { StatisticCalcs::DataSet.new(x_values: x_values) }

  before { subject.analyze! }
  describe '.mean' do
    context 'Ungrouped data' do
      context 'with values' do
        let(:x_values) { [-5, 1.2, 2.3, 3.4] }
        context 'give the average of the list' do
          it 'return 0.457' do
            expect(subject.mean).to eq(0.475)
          end
        end
        context 'without values' do
          let(:x_values) { [] }
          context 'give the average of the list' do
            it 'return nil' do
              expect(subject.mean).to be_nil
            end
          end
        end
      end
    end

    context 'Grouped data' do
      context 'with values' do
        let(:x_values) { [1.2, 2.3, 3.4, 1] }
        let(:lower_class_boundary_values) { [1.2, 4.3, 9.4, 14.5] }
        let(:upper_class_boundary_values) { [4.3, 9.4, 14.5, 19.6] }
        subject do
          StatisticCalcs::GroupedDataSet.new(
            x_values: x_values,
            lower_class_boundary_values: lower_class_boundary_values,
            upper_class_boundary_values: upper_class_boundary_values
          )
        end
        before { subject.analyze! }

        context 'give the average of the list' do
          it 'return 0.457' do
            expect(subject.mean).to eq(19.18375)
          end
        end
        context 'without values' do
          let(:x_values) { [] }
          context 'give the average of the list' do
            it 'return nil' do
              expect(subject.mean).to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable BlockLength
