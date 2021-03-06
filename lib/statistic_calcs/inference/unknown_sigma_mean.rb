# frozen_string_literal: true

require 'statistic_calcs/inference/mean'
require 'statistic_calcs/distributions/t_student'

module StatisticCalcs
  module Inference
    # If you don't know the standard deviation of the population
    # you can use the sample one.
    # The population mean have a t Student behavior
    class UnknownSigmaMean < Mean
      attr_accessor :sample_standard_deviation

      attr_alias :standard_deviation, :sample_standard_deviation
      attr_alias :t, :deviation_amount

      def init!
        super
        self.sample_size = calc_sample_size! unless sample_size
        self.t = t_student_dist(sample_size - 1).calc!.x
      end

      def calc_sample_size!
        calc_sample_size_iterative_method(500, 5)
      end

      def calc_sample_size_iterative_method(n, max_tries)
        return n if max_tries.negative?

        t_value = t_student_dist(n - 1).calc!.x
        temp = ((t_value * sample_standard_deviation / sample_error)**2).ceil

        return calc_sample_size_iterative_method(temp, max_tries - 1) unless temp == n
        temp
      end

      def t_student_dist(degrees_of_freedom)
        StatisticCalcs::Distributions::TStudent.new(f_x: 1.0 - alpha / 2, v: degrees_of_freedom)
      end
    end
  end
end
