# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes'
require 'statistic_calcs/inference/errorable'

module StatisticCalcs
  module Inference
    # The estimation of the population mean, is calculated using `x`` (average of a sample)
    # Inference the `mean upper-lower limits` `P(A < mu < B) = 1 - alpha`
    # or the `sample_size` if you define the `sample_error`
    class Mean
      include StatisticCalcs::Inference::Errorable
      include StatisticCalcs::Helpers::AliasAttributes

      attr_accessor :population_size, :population_mean_lower_limit, :population_mean_upper_limit,
                    :sample_size, :sample_mean,
                    :deviation_amount, :sample_error

      attr_alias :x, :sample_mean
      attr_alias :n, :population_size
      attr_alias :size, :population_size
      attr_alias :lower_limit, :population_mean_lower_limit
      attr_alias :upper_limit, :population_mean_upper_limit

      def calc!
        init!
        validate!
        calculate!
      end

      private

      def validate!
        super
        raise StandardError, 'sample_size or sample_error is required' unless sample_error || sample_size
      end

      def calculate!
        calc_sample_size! unless sample_size
        self.sample_error ||= deviation_amount * standard_deviation / Math.sqrt(sample_size) * finite_population_correction
        self.lower_limit = sample_mean - sample_error
        self.upper_limit = sample_mean + sample_error
        self.sample_error = sample_error.ceil
      end

      # Correction factor when the population size is known
      def finite_population_correction
        return Math.sqrt((population_size.to_f - sample_size) / population_size) if population_size
        1.0
      end

      def calc_sample_size!
        self.sample_size = ((z * standard_deviation / sample_error)**2).ceil
        # Correction factor when the population size is known
        self.sample_size = (population_size.to_f * sample_size / (population_size + sample_size)).ceil if population_size
      end
    end
  end
end
