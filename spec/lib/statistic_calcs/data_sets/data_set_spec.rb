# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/data_sets/data_set_spec.rb
require 'statistic_calcs/data_sets/data_set'

RSpec.describe StatisticCalcs::DataSets::DataSet do
  subject { StatisticCalcs::DataSets::DataSet.new(x_values: x_values) }

  before { subject.calc! }
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
              expect(subject.mean).to be(0)
            end
          end
        end
      end
    end
  end
end
