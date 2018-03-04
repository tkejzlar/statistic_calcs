# frozen_string_literal: true

require 'statistic_calcs/data_sets/data_set'
require 'statistic_calcs/data_sets/grouped_data_set'
require 'statistic_calcs/chi_square_contrast/base'

module StatisticCalcs
  module ChiSquareContrast
    # Check if a list of values is adjusted to a law or model
    class GoodnessAndFit < Base
      attr_accessor :parameter_quantity, # how many parameter to estimate in the distribution
                    :data_set, # list of values without process
                    :lower_class_boundary_values, :upper_class_boundary_values,
                    :mean, :standard_deviation, :variance

      def init!
        super
        group_data_set_by_frequency! if data_set
        set_data_set_by_frequency! if lower_class_boundary_values && upper_class_boundary_values
        self.occurrence_probabilities = observed_frequencies.each_with_index.map { |value, index| success_probability(index, value) }
        self.expected_frequencies = occurrence_probabilities.map { |value| value * sample_size }
      end

      def validate!
        super
        raise StandardError, 'Parameter quantity is required' unless parameter_quantity
      end

      def degrees_of_freedom
        clusters_count - 1 - parameter_quantity
      end

      def success_probability(_cluster)
        raise :not_implemented
      end

      def executed?
        !@critical_chi_square.nil?
      end

      private

      # rubocop:disable MethodLength
      def set_data_set_by_frequency!
        calc = StatisticCalcs::DataSets::GroupedDataSet.new(
          lower_class_boundary_values: lower_class_boundary_values,
          upper_class_boundary_values: upper_class_boundary_values,
          frequency: observed_frequencies
        ).calc!
        self.clusters = calc.histogram_keys
        self.mid_points = calc.histogram_values_mid_points
        self.cluster_keys = calc.histogram_keys
        self.cluster_values = calc.adjusted_keys
        self.mean = calc.mean
        self.variance = calc.variance
        self.standard_deviation = calc.standard_deviation
      end

      def group_data_set_by_frequency!
        calc = StatisticCalcs::DataSets::DataSet.new(x_values: data_set)
        calc.split_in(clusters_count)
        self.sample_size = data_set.count
        self.clusters = calc.histogram_keys
        self.observed_frequencies = calc.histogram_values
        self.mid_points = calc.histogram_values_mid_points
        self.cluster_keys = calc.histogram_keys
        self.cluster_values = calc.adjusted_keys
      end
      # rubocop:enable MethodLength
    end
  end
end
