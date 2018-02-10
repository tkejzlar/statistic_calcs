# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes.rb'
require 'statistic_calcs/descriptive/distributions/normal.rb'

module StatisticCalcs
  module Inference
    class Mean
      include StatisticCalcs::Helpers::AliasAttributes

      attr_accessor :population_mean, :population_size, :population_mean_lower_limit, :population_mean_upper_limit,
                    :sample_size, :sample_mean,
                    :alpha, :beta, :deviation_amount, :sample_error

      attr_alias :mean, :population_mean
      attr_alias :mu, :mean
      attr_alias :size, :population_size
      attr_alias :lower_limit, :population_mean_lower_limit
      attr_alias :upper_limit, :population_mean_upper_limit
      attr_alias :z, :deviation_amount

      # TODO: Repeated code in base.rb
      def initialize(args)
        args.each do |key, value|
          send("#{key}=", value) unless value.nil?
        end
      end

      def calc!
        self.alpha ||= 0.05
        calc_sample_size! unless sample_size

        self.z = normal_dist.calc!.x
        self.sample_error = z * standard_deviation / Math.sqrt(sample_size) * finite_population_correction
        self.lower_limit = sample_mean - sample_error
        self.upper_limit = sample_mean + sample_error
        self.sample_error = sample_error.ceil
      end

      private

      # Correction factor when the population size is known
      def finite_population_correction
        return Math.sqrt((population_size.to_f - sample_size) / population_size) if population_size
        1.0
      end

      def calc_sample_size!
        self.sample_size = ((z * standard_deviation / sample_error)**2).ceil
        # Correction factor when the population size is known
        self.sample_size = (population_size * sample_size / population_size + sample_size).ceil if population_size
      end

      def normal_dist
        StatisticCalcs::Descriptive::Distributions::Normal.new(f_x: 1.0 - alpha)
      end
    end
  end
end
