# frozen_string_literal: true

require 'gsl'

module StatisticCalcs
  module Descriptive
    module Analysis
      attr_accessor :mean, :variance, :standard_deviation,
                    :max, :min, :skew, :kurtosis, :median, :mode,
                    :sum, :n

      def analyze!
        return unless x_values.any?
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
