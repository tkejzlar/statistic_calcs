# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/chi_square_contrast/normal_goodness_and_fit_spec.rb
require 'statistic_calcs/chi_square_contrast/normal_goodness_and_fit'

RSpec.describe StatisticCalcs::ChiSquareContrast::NormalGoodnessAndFit do
  subject { StatisticCalcs::ChiSquareContrast::NormalGoodnessAndFit.new(options) }

  describe 'test if the list of values apply to a uniform law' do
    context 'valid scenarios' do
      let(:lower_class_boundary_values) { [9, 11, 13, 15, 17, 19, 21] }
      let(:upper_class_boundary_values) { [11, 13, 15, 17, 19, 21, 23] }
      let(:observed_frequencies) { [8, 15, 45, 58, 65, 50, 39] }
      let!(:options) { { lower_class_boundary_values: lower_class_boundary_values, upper_class_boundary_values: upper_class_boundary_values, observed_frequencies: observed_frequencies } }

      context 'calculate' do
        before do
          subject.calc!
        end

        it 'generate the goodness and fit tables and values' do
          expect(subject.cluster_mid_points).to eq([10.0, 12.0, 14.0, 16.0, 18.0, 20.0, 22.0])
          expect(subject.occurrence_probabilities).to eq([0.02118, 0.06165999999999999, 0.14604, 0.23174999999999998, 0.24643000000000004, 0.17562, 0.11732])
          expect(subject.expected_frequencies).to eq([5.930400000000001, 17.264799999999997, 40.8912, 64.89, 69.00040000000001, 49.1736, 32.849599999999995])
          expect(subject.critical_chi_square).to eq(3.5611)
        end
      end
    end
  end
end
