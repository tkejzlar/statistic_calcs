# frozen_string_literal: true

# rspec ./spec/lib/statistic_calcs/chi_square_contrast/gumbel_minimum_goodness_and_fit_spec.rb
require 'statistic_calcs/chi_square_contrast/gumbel_minimum_goodness_and_fit'

RSpec.describe StatisticCalcs::ChiSquareContrast::GumbelMinimumGoodnessAndFit do
  subject { StatisticCalcs::ChiSquareContrast::GumbelMinimumGoodnessAndFit.new(options) }

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
          expect(subject.beta).to eq(60.778432093425295)
          expect(subject.cluster_mid_points).to eq([7.5, 22.5, 37.5, 52.5, 67.5, 90.0, 152.5])
          expect(subject.occurrence_probabilities).to eq([0.6133, 0.09030000000000005, 0.08552000000000004, 0.07447999999999999, 0.05830000000000002, 0.06275999999999993, 0.01534])
          expect(subject.expected_frequencies).to eq([80.3423, 11.829300000000007, 11.203120000000006, 9.756879999999999, 7.637300000000002, 8.22155999999999, 2.00954])
          expect(subject.critical_chi_square).to eq(206.1952)
        end
      end
    end
  end
end
