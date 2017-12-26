# frozen_string_literal: true

require 'gsl'

module StatisticCalcs
  module Descriptive
    module Analysis
      attr_reader :mean, :variance, :standard_deviation,
                  :max, :min, :skew, :kurtosis, :median, :mode

      def analyze!
        return unless x_values.any?
        @mean = gsl.mean.round(StatisticCalcs::DECIMALS)
        @variance = gsl.variance.round(StatisticCalcs::DECIMALS)
        @standard_deviation = gsl.sd
        @max = gsl.max.round(StatisticCalcs::DECIMALS)
        @min = gsl.min.round(StatisticCalcs::DECIMALS)
        @skew = gsl.skew.round(StatisticCalcs::DECIMALS)
        @kurtosis = gsl.kurtosis.round(StatisticCalcs::DECIMALS)
        @median = gsl.median.round(StatisticCalcs::DECIMALS)
        # @mode = gsl.mode
      end

      private

      def gsl
        GSL::Vector[data_set]
      end

      def data_set
        grouped_data? ? grouped_frequency : x_values
      end

      def grouped_frequency
        temp = []
        mid_points.each_with_index { |mid, i| temp << mid * x_values[i] }
        temp
      end

      def grouped_data?
        respond_to?(:mid_points)
      end
    end
  end
end
