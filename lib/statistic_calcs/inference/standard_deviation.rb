# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes.rb'
require 'statistic_calcs/inference/variance.rb'
require 'statistic_calcs/inference/errorable.rb'

module StatisticCalcs
  module Inference
    # Inference the `standard deviation upper-lower limits` `P(A < sigma < B) = 1 - alpha`
    # or the `sample size`.
    # From a population, knowing information of a sample group
    class StandardDeviation
      include StatisticCalcs::Inference::Errorable
      include StatisticCalcs::Helpers::AliasAttributes

      attr_accessor :population_standard_deviation_lower_limit, :population_standard_deviation_upper_limit, :limits_relationship_standard_deviation,
                    :sample_standard_deviation, :sample_size, :sample_error, :alpha,
                    :degrees_of_freedom, :garcia_a

      attr_alias :lower_limit, :population_standard_deviation_lower_limit
      attr_alias :upper_limit, :population_standard_deviation_upper_limit
      attr_alias :r, :limits_relationship_standard_deviation

      def calc!
        init!
        validate!
        calculate!
        self
      end

      private

      def init!
        super
        self.degrees_of_freedom ||= sample_size - 1 if sample_size
      end

      def validate!
        super
        raise StandardError, 'limits_relationship_standard_deviation is required to calculate the sample size' if sample_size.nil? && r.nil?
        raise StandardError, 'limits_relationship_standard_deviation <> 1 is required to calculate the sample size' if r == 1
      end

      def calculate!
        variance_inference_result = variance_inference.calc!
        self.degrees_of_freedom ||= variance_inference_result.degrees_of_freedom
        self.sample_size ||= variance_inference_result.sample_size
        self.limits_relationship_standard_deviation ||= variance_inference_result.limits_relationship_variance**0.5

        self.lower_limit = variance_inference_result.lower_limit**0.5
        self.upper_limit = variance_inference_result.upper_limit**0.5
        self.sample_error = (upper_limit - lower_limit) / 2
      end

      def variance_inference
        StatisticCalcs::Inference::Variance.new(variance_options)
      end

      def variance_options
        temp = {
          alpha: alpha,
          sample_variance: sample_standard_deviation**2,
          sample_size: sample_size
        }
        temp[:limits_relationship_variance] = limits_relationship_standard_deviation**2 if limits_relationship_standard_deviation
        temp
      end
    end
  end
end
