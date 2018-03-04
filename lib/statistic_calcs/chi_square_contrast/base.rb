# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes'
require 'statistic_calcs/distributions/chi_square'
require 'statistic_calcs/helpers/array_validations'
require 'statistic_calcs/data_sets/data_set'

require 'pry'

module StatisticCalcs
  module ChiSquareContrast
    # Check consistency between theoric/expected values and the current one
    class Base
      include StatisticCalcs::Helpers::AliasAttributes
      include StatisticCalcs::Helpers::ArrayValidations

      MIN_EXPECTED_FREQ = 5
      MIN_N = 60

      attr_accessor :sample_size, :clusters, :clusters_count,
                    :cluster_mid_points, :occurrence_probabilities,
                    :observed_frequencies, :expected_frequencies,
                    :cluster_keys, :cluster_values

      attr_alias :n, :sample_size
      attr_alias :mid_points, :cluster_mid_points
      attr_alias :intervals, :clusters
      attr_alias :classes, :clusters

      def calc!
        return self if executed?
        init!
        validate!
      end

      def init!
        self.clusters_count ||= observed_frequencies&.count || 20
        self.observed_frequencies ||= []
        self.sample_size = observed_frequencies_sum
      end

      def validate!
        super(:observed_frequencies)
        super(:expected_frequencies)
        raise StandardError, 'Observed, expected and probabilities should have the same amount of values' unless same_quantity?
        raise StandardError, "Sample size should be greater than #{MIN_N}" if sample_size < MIN_N
        # raise StandardError, "Expected frequency should be greater than #{MIN_EXPECTED_FREQ}" if any_expected_freq_under_min?
      end

      def degrees_of_freedom
        clusters_count - 1
      end

      def critical_chi_square
        @critical_chi_square ||= (0..clusters_count).inject do |acum, index|
          expected_frequency = expected_frequencies[index - 1]
          observed_frequency = observed_frequencies[index - 1]
          acum + ((observed_frequency - expected_frequency)**2).to_f / expected_frequency
        end.round(4)
      end

      private

      def observed_frequencies_sum
        observed_frequencies.inject(0) { |acum, val| acum + val }
      end

      def same_quantity?
        occurrence_probabilities.count == observed_frequencies.count
        #  == expected_frequencies.count
      end

      def any_expected_freq_under_min?
        expected_frequencies.any? { |val| val < MIN_EXPECTED_FREQ }
      end
    end
  end
end
