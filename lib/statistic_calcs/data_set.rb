# frozen_string_literal: true

require 'statistic_calcs/descriptive/analysis.rb'

module StatisticCalcs
  # == Statistic \Calc \Dataset
  #
  # Provides an interface for a data set to be analyzed using statistic calculations
  #
  class DataSet
    include StatisticCalcs::Descriptive::Analysis

    attr_reader :x_values

    def initialize(options = {})
      @x_values = options.fetch(:x_values, [])
    end
  end
end
