# frozen_string_literal: true

require 'statistic_calcs/distributions/chi_square'
require 'statistic_calcs/distributions/normal'
require 'statistic_calcs/helpers/alias_attributes'
require 'statistic_calcs/helpers/garcia_equation'
require 'statistic_calcs/inference/errorable'

module StatisticCalcs
  module Inference
    # Inference the `variance upper-lower limits` `P(A < sigma^2 < B) = 1 - alpha`
    # or the required `sample size`.
    # From a population, knowing information of a sample group
    class Variance
      include StatisticCalcs::Inference::Errorable
      include StatisticCalcs::Helpers::AliasAttributes

      attr_accessor :population_variance_lower_limit, :population_variance_upper_limit, :limits_relationship_variance,
                    :sample_variance, :sample_size, :sample_error,
                    :degrees_of_freedom, :garcia_a

      attr_alias :lower_limit, :population_variance_lower_limit
      attr_alias :upper_limit, :population_variance_upper_limit
      attr_alias :r, :limits_relationship_variance

      def calc!
        init!
        validate!
        calculate!
        self
      end

      private

      def init!
        super
        self.degrees_of_freedom ||= sample_size - 1 if sample_size
      end

      def validate!
        super
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
        StatisticCalcs::Distributions::Normal.new(f_x: 1.0 - alpha / 2)
      end

      def chi_square_dist(f_x)
        StatisticCalcs::Distributions::ChiSquare.new(f_x: f_x, degrees_of_freedom: degrees_of_freedom)
      end
    end
  end
end
