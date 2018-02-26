# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/chi_square_contrast/gumbel_maximum_goodness_and_fit_spec.rb
require 'statistic_calcs/chi_square_contrast/gumbel_maximum_goodness_and_fit'

RSpec.describe StatisticCalcs::ChiSquareContrast::GumbelMaximumGoodnessAndFit do
  subject { StatisticCalcs::ChiSquareContrast::GumbelMaximumGoodnessAndFit.new(options) }

  describe 'test if the list of values apply to a uniform law' do
    context 'valid scenarios' do
      let(:lower_class_boundary_values) { [0, 15, 30, 45, 60, 75, 105] }
      let(:upper_class_boundary_values) { [15, 30, 45, 60, 75, 105, 200] }
      let(:observed_frequencies) { [8, 20, 25, 35, 25, 18, 0] }
      let!(:options) { { lower_class_boundary_values: lower_class_boundary_values, upper_class_boundary_values: upper_class_boundary_values, observed_frequencies: observed_frequencies } }

      context 'calculate' do
        before do
          subject.calc!
        end

        it 'generate the goodness and fit tables and values' do
          expect(subject.thita).to eq(18.111089577398445)
          expect(subject.beta).to eq(39.87042286840676)
          expect(subject.cluster_mid_points).to eq([7.5, 22.5, 37.5, 52.5, 67.5, 90.0, 152.5])
          expect(subject.occurrence_probabilities).to eq([0.3392, 0.13688, 0.12474000000000002, 0.10407, 0.08168999999999993, 0.10646, 0.10696])
          expect(subject.expected_frequencies).to eq([44.4352, 17.93128, 16.340940000000003, 13.63317, 10.701389999999991, 13.94626, 14.01176])
          expect(subject.critical_chi_square).to eq(102.4852)
        end
      end
    end
  end
end
