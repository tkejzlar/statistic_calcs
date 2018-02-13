# frozen_string_literal: true

require 'statistic_calcs/inference/mean.rb'
require 'statistic_calcs/descriptive/distributions/normal.rb'

module StatisticCalcs
  module Inference
    # If you know the standard deviation of the population
    # The population mean have a standard Normal behavior
    class KnownSigmaMean < Mean
      attr_accessor :population_standard_deviation

      attr_alias :standard_deviation, :population_standard_deviation
      attr_alias :z, :deviation_amount

      def init!
        super
        self.z = normal_dist.calc!.x
      end

      def normal_dist
        StatisticCalcs::Descriptive::Distributions::Normal.new(f_x: 1.0 - alpha / 2)
      end
    end
  end
end
