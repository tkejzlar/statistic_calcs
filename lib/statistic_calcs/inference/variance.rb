# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes.rb'
require 'statistic_calcs/helpers/garcia_equation.rb'
require 'statistic_calcs/descriptive/distributions/normal.rb'
require 'statistic_calcs/descriptive/distributions/chi_square.rb'

module StatisticCalcs
  module Inference
    # Inference the `variance upper-lower limits`, `sample error`, `error relationship between limits`, `sample size`.
    # From a population, knowing information of a sample group
    class Variance
      include StatisticCalcs::Helpers::AliasAttributes

      attr_accessor :population_variance_lower_limit, :population_variance_upper_limit, :limits_relationship_variance,
                    :sample_variance, :sample_size, :sample_error, :alpha,
                    :degrees_of_freedom, :garcia_a

      attr_alias :lower_limit, :population_variance_lower_limit
      attr_alias :upper_limit, :population_variance_upper_limit
      attr_alias :r, :limits_relationship_variance

      def calc!
        init!
        validate!
        calculate!
      end

      private

      def init!
        self.alpha ||= 0.05
        self.degrees_of_freedom ||= sample_size - 1 if sample_size
      end

      def validate!
        raise StandardError, 'alpha should be between 0 and 1' unless alpha.between?(0, 1)
        raise StandardError, 'limits_relationship_variance is required to calculate the sample size' if sample_size.nil? && r.nil?
        raise StandardError, 'limits_relationship_variance <> 1 is required to calculate the sample size' if r == 1
      end

      def calculate!
        calc_sample_size! unless sample_size


        chi_inf_variance = chi_square_dist(1 - (alpha / 2)).calc!.x
        chi_sup_variance = chi_square_dist(alpha / 2).calc!.x

        self.lower_limit = degrees_of_freedom * sample_variance / chi_inf_variance
        self.upper_limit = degrees_of_freedom * sample_variance / chi_sup_variance
        self.sample_error = (upper_limit - lower_limit) / 2
        self.limits_relationship_variance = upper_limit / lower_limit
      end

      def calc_sample_size!
        z = normal_dist.calc!.x
        tmp = r**(1.0 / 3)
        garcia_a = z * (tmp + 1) / (2 * (tmp - 1))
        self.degrees_of_freedom = ::StatisticCalcs::Helpers::GarciaEquation.calc!(garcia_a)
        self.sample_size = degrees_of_freedom + 1
      end

      def normal_dist
        StatisticCalcs::Descriptive::Distributions::Normal.new(f_x: 1.0 - alpha / 2)
      end

      def chi_square_dist(f_x)
        StatisticCalcs::Descriptive::Distributions::ChiSquare.new(f_x: f_x, degrees_of_freedom: degrees_of_freedom)
      end
    end
  end
end
