# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/chi_square_contrast/log_normal_goodness_and_fit_spec.rb
require 'statistic_calcs/chi_square_contrast/log_normal_goodness_and_fit'

RSpec.describe StatisticCalcs::ChiSquareContrast::LogNormalGoodnessAndFit do
  subject { StatisticCalcs::ChiSquareContrast::LogNormalGoodnessAndFit.new(options) }

  describe 'test if the list of values apply to a uniform law' do
    context 'valid scenarios' do
      let(:lower_class_boundary_values) { [0, 100, 200, 300, 400, 500, 600] }
      let(:upper_class_boundary_values) { [100, 200, 300, 400, 500, 600, 1400] }
      let(:observed_frequencies) { [15, 44, 38, 22, 14, 9, 2] }
      let!(:options) { { lower_class_boundary_values: lower_class_boundary_values, upper_class_boundary_values: upper_class_boundary_values, observed_frequencies: observed_frequencies } }

      context 'calculate' do
        before do
          subject.calc!
        end

        it 'generate the goodness and fit tables and values' do
          expect(subject.cluster_mid_points).to eq([50.0, 150.0, 250.0, 350.0, 450.0, 550.0, 1000.0])
          expect(subject.occurrence_probabilities).to eq([0.07788, 0.34426, 0.27597, 0.14958000000000005, 0.0745499999999999, 0.0370100000000001, 0.04075])
          expect(subject.expected_frequencies).to eq([11.21472, 49.573440000000005, 39.73968, 21.539520000000007, 10.735199999999985, 5.329440000000014, 5.868])
          expect(subject.critical_chi_square).to eq(8.0608)
        end
      end
    end
  end
end
