# frozen_string_literal: true

require 'gsl'
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
                    :max, :min, :skew, :kurtosis, :median, :mode,
                    :sum, :n, :x_values

      def initialize(options = {})
        @x_values = options.fetch(:x_values, [])
        self.mean = 0
        self.variance = 0
        self.standard_deviation = 0
      end

      def calc!
        return self unless x_values.any? || already_calc?
        set_gsl_values
        self.n = x_values.count
        self.sum = mean * n
        self
      end

      private

      def set_gsl_values
        self.mean = gsl.mean.round(StatisticCalcs::DECIMALS)
        self.variance = gsl.variance.round(StatisticCalcs::DECIMALS)
        self.standard_deviation = gsl.sd
        self.max = gsl.max.round(StatisticCalcs::DECIMALS)
        self.min = gsl.min.round(StatisticCalcs::DECIMALS)
        self.skew = gsl.skew.round(StatisticCalcs::DECIMALS)
        self.kurtosis = gsl.kurtosis.round(StatisticCalcs::DECIMALS)
        self.median = gsl.median.round(StatisticCalcs::DECIMALS)
      end

      def gsl
        GSL::Vector[x_values]
      end

      def already_calc?
        n&.positive?
      end
    end
  end
end
