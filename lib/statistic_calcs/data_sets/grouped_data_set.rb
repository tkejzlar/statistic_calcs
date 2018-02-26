# frozen_string_literal: true

require 'statistic_calcs/data_sets/histogram_grouper'
require 'pry'

module StatisticCalcs
  module DataSets
    # == Statistic \Calc \Grouped Dataset
    #
    # Provides an interface for a data set to be analyzed using statistic calculations
    #
    class GroupedDataSet
      include HistogramGrouper

      attr_accessor :lower_class_boundary_values, :upper_class_boundary_values, :mid_points, :intervals, :x_values,
                    :range, :max, :min, :skew, :kurtosis, :median, :mode, :sum, :n

      def initialize(options = {})
        @x_values = options.fetch(:x_values, [])
        @frequency = options[:frequency]
        calc_class_boundary_values_values(options)
        @intervals = lower_class_boundary_values&.count
        @range = upper_class_boundary_values.first - lower_class_boundary_values.first if upper_class_boundary_values.any?
        calculate_grouped_data!
      end

      def calc!
        self.n = x_values.any? ? x_values.count : frequency.inject { |sum, value| sum + value }
        self.sum = x_values.inject { |sum, value| sum + value }
        self.max = x_values.max
        self.min = x_values.min
        self
      end

      def standard_deviation
        @standard_deviation ||= variance**0.5
      end

      def variance
        @variance ||= begin
          tmp = 0
          mid_points.each_with_index do |mid_point, index|
            tmp += ((mid_point - mean)**2) * frequency[index]
          end
          tmp / (n - 1)
        end
      end

      def mean
        @mean ||= begin
          return 0 unless n
          tmp = 0
          mid_points.each_with_index do |mid_point, index|
            tmp += mid_point * frequency[index]
          end
          tmp / n
        end
      end

      # rubocop:disable MethodLength
      # example ["600..700.0", "700.0..800.0", "800.0..900.0", "900.0..1000"]
      def calc_class_boundary_values_values(options)
        if options[:class_boundary_values_values]
          list = options[:class_boundary_values_values].map { |value| value.split('..') }
          @lower_class_boundary_values = []
          @upper_class_boundary_values = []
          list.each do |values|
            @lower_class_boundary_values << values[0].to_f
            @upper_class_boundary_values << values[1].to_f
          end
        end
        @lower_class_boundary_values ||= options[:lower_class_boundary_values] || []
        @upper_class_boundary_values ||= options[:upper_class_boundary_values] || []
      end

      def frequency
        @frequency ||= begin
          lower_value = lower_class_boundary_values.first
          result = {}
          intervals.times do |i|
            result[i] = 0
          end

          x_values.each do |value|
            temp =  ((value - lower_value) / range).to_i
            temp -= 1 unless result[temp]
            result[temp] += 1
          end
          result.values
        end
      end
      # rubocop:enable MethodLength

      private

      def grouped_frequency
        temp = []
        mid_points.each_with_index { |mid, i| temp << mid * frequency[i] }
        temp
      end

      def calculate_grouped_data!
        @mid_points = []
        lower_class_boundary_values.each_with_index do |l1, i|
          mid_points << l1 + ((upper_class_boundary_values[i] - l1).to_f / 2)
        end
      end

      def wrong_grouped_data?
        grouped_data? &&
          lower_class_boundary_values.nil? || upper_class_boundary_values.nil?
      end

      def validations
        raise 'Grouped data can\'t be calculated without lower and upper class boundaries values' if wrong_grouped_data?
        # raise 'Upper class boundary can\'t be lower than Lower one' unless l2 >= l1
      end
    end
  end
end
