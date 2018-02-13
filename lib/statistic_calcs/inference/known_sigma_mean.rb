# frozen_string_literal: true

require 'statistic_calcs/inference/mean.rb'
require 'statistic_calcs/descriptive/distributions/normal.rb'

module StatisticCalcs
  module Inference
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
