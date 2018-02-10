# frozen_string_literal: true

require 'statistic_calcs/inference/mean.rb'

module StatisticCalcs
  module Inference
    class KnownSigmaMean < Mean
      attr_accessor :population_standard_deviation

      attr_alias :standard_deviation, :population_standard_deviation
    end
  end
end
