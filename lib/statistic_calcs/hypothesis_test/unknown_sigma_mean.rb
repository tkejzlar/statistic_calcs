# frozen_string_literal: true

require 'statistic_calcs/hypothesis_test/mean.rb'
require 'statistic_calcs/descriptive/distributions/t_student.rb'

module StatisticCalcs
  module HypothesisTest
    # Test a mean for with the sample standard deviation using T distribution
    class UnknownSigmaMean < Mean
      attr_accessor :sample_standard_deviation

      attr_alias :standard_deviation, :sample_standard_deviation
      attr_alias :sigma, :sample_standard_deviation

      required %i[standard_deviation sample_size sample_mean mean_to_test case]

      private

      def distribution(f_x)
        StatisticCalcs::Descriptive::Distributions::TStudent.new(f_x: f_x, degrees_of_freedom: degrees_of_freedom).calc!.x
      end
    end
  end
end
