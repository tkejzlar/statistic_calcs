# frozen_string_literal: true

module StatisticCalcs
  # == Statistic \Calc \Grouped Dataset
  #
  # Provides an interface for a data set to be analyzed using statistic calculations
  #
  class GroupedDataSet < DataSet
    attr_reader :lower_class_boundary_values, :upper_class_boundary_values, :mid_points

    def initialize(options = {})
      super(options)
      @lower_class_boundary_values = options[:lower_class_boundary_values]
      @upper_class_boundary_values = options[:upper_class_boundary_values]
      calculate_grouped_data
    end

    private

    def calculate_grouped_data
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
