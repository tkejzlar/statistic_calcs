# frozen_string_literal: true

require 'descriptive_statistics'
require 'statistic_calcs/data_sets/histogram_grouper'

module StatisticCalcs
  module DataSets
    # == Statistic \Calc \Dataset
    #
    # Provides an interface for a data set to be analyzed using statistic calculations
    #
    class DataSet
      include HistogramGrouper

      attr_accessor :mean, :variance, :standard_deviation,
                    :max, :min, :median, :mode,
                    :sum, :n, :x_values

      def initialize(options = {})
        @x_values = options.fetch(:x_values, [])
        self.mean = 0
        self.variance = 0
        self.standard_deviation = 0
      end

      def calc!
        return self unless x_values.any? || already_calc?
        set_stat_values
        self.n = x_values.count
        self.sum = mean * n
        self
      end

      private

      def set_stat_values
        self.mean = stats.mean.round(StatisticCalcs::DECIMALS)
        self.variance = stats.variance.round(StatisticCalcs::DECIMALS)
        self.standard_deviation = stats.standard_deviation
        self.max = stats.max.round(StatisticCalcs::DECIMALS)
        self.min = stats.min.round(StatisticCalcs::DECIMALS)
        self.median = stats.median.round(StatisticCalcs::DECIMALS)
        self.mode = stats.mode.round(StatisticCalcs::DECIMALS)
      end

      def stats
        DescriptiveStatistics::Stats.new(x_values)
      end

      def already_calc?
        n&.positive?
      end
    end
  end
end
