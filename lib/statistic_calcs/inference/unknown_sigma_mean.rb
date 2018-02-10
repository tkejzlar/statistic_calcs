# frozen_string_literal: true

require 'statistic_calcs/inference/mean.rb'

module StatisticCalcs
  module Inference
    # This class will use a sample standard deviation to inference the sample mean
    class UnknownSigmaMean < Mean
      attr_accessor :sample_standard_deviation

      attr_alias :standard_deviation, :sample_standard_deviation
    end
  end
end
