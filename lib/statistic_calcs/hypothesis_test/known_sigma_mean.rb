# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/mean'
require 'statistic_calcs/distributions/normal'

module StatisticCalcs
  module HypothesisTest
    # Test a mean for known sigma, using Normal distribution
    class KnownSigmaMean < Mean
      attr_accessor :population_standard_deviation

      attr_alias :standard_deviation, :population_standard_deviation
      attr_alias :sigma, :population_standard_deviation

      required %i[standard_deviation sample_size sample_mean mean_to_test case]

      private

      def distribution(f_x)
        StatisticCalcs::Distributions::Normal.new(f_x: f_x).calc!.x
      end
    end
  end
end
