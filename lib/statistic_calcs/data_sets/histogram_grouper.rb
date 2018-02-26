# frozen_string_literal: true

module StatisticCalcs
  module DataSets
    module HistogramGrouper
      attr_accessor :intervals, :range, :lower_class_boundary_values, :upper_class_boundary_values

      def split_in(intervals)
        calc!
        self.intervals = intervals
        self.range = (max - min).to_f / intervals
        self
      end

      def group_each(range)
        calc!
        self.range = range
        self.intervals = ((max - min).to_f / range).ceil
        self
      end

      def adjusted_keys
        histogram_keys.map do |value|
          if lower_class_boundary_values&.any?
            value.sub('less_than_', "#{lower_class_boundary_values.first}..").sub('_or_more_than', "..#{upper_class_boundary_values.last}")
          else
            value.sub('less_than_', "#{min}..").sub('_or_more_than', "..#{max}")
          end
        end
      end

      def histogram_values_mid_points
        adjusted_keys.map do |value|
          lower, upper = value.split('..').map(&:to_f)
          ((upper - lower).to_f / 2) + lower
        end
      end

      # rubocop:disable MethodLength
      def histogram_keys
        @histogram_keys ||= lower_class_boundary_values&.any? ? generate_histogram_keys_by_boundary_values : generate_histogram_keys_by_intervals
      end

      def histogram_values
        @histogram_values ||= begin
          result = {}
          intervals.times do |i|
            result[i] = 0
          end

          x_values.each do |value|
            temp =  ((value - min) / range).to_i
            temp -= 1 unless result[temp]
            result[temp] += 1
          end
          result.values
        end
      end

      def grouped_values
        @grouped_values ||= begin
          result = {}
          intervals.times do |i|
            result[i] = []
          end

          x_values.each do |value|
            temp =  ((value - min) / range).to_i
            temp -= 1 unless result[temp]
            result[temp] << value
          end
          result.values
        end
      end
      # rubocop:enable MethodLength

      def grouped_values_hash
        histogram_keys.each_with_index.map do |value, index|
          [value, grouped_values[index]]
        end.to_h
      end

      def min
        @min ||= x_values.min
      end

      def max
        @max ||= x_values.max
      end

      private

      # rubocop:disable MethodLength
      def generate_histogram_keys_by_intervals
        result = []
        intervals.times do |i|
          result << if i.zero?
                      "less_than_#{min + range}"
                    elsif i == (intervals - 1)
                      "#{max - range}_or_more_than"
                    else
                      "#{min + i * range}..#{min + (i + 1) * range}"
                    end
        end
        result
      end

      def generate_histogram_keys_by_boundary_values
        self.intervals = lower_class_boundary_values.count
        result = []
        lower_class_boundary_values.each_with_index do |lower, i|
          upper = upper_class_boundary_values[i]
          result << if i.zero?
                      "less_than_#{upper}"
                    elsif i == (intervals - 1)
                      "#{lower}_or_more_than"
                    else
                      "#{lower}..#{upper}"
                    end
        end
        result
      end
      # rubocop:enable MethodLength
    end
  end
end
