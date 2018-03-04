# frozen_string_literal: true

require 'statistic_calcs/distributions/binomial'
require 'statistic_calcs/helpers/alias_attributes'
require 'statistic_calcs/inference/errorable'

module StatisticCalcs
  module Inference
    # In a Bernoulli process, if the sampling is made to the Binomial
    # the size of the sample `n` is fixed and the number of successes obtained `r` is observed in the sample.

    # Therefore, the estimator `p` is a random variable of Binomial behavior
    # corresponding to the probability of success of the Process a Bernoulli Process.
    # Sample p'= r /n and population is P(A < p < B) = 1 - alpha.
    class PBernoulliProcess
      include StatisticCalcs::Inference::Errorable
      include StatisticCalcs::Helpers::AliasAttributes

      attr_accessor :sample_size, :number_successes, :sample_probability_of_success,
                    :probability_of_success_lower_limit, :probability_of_success_upper_limit, :sample_error

      attr_alias :r, :number_successes
      attr_alias :n, :sample_size
      attr_alias :sample_p, :sample_probability_of_success
      attr_alias :lower_limit, :probability_of_success_lower_limit
      attr_alias :upper_limit, :probability_of_success_upper_limit

      def calc!
        init!
        validate!
        calculate!
      end

      private

      def init!
        super
        self.sample_probability_of_success = r.to_f / n
      end

      def validate!
        super
        raise StandardError, 'number_successes couldn\'t be greater than sample_size' unless n >= r
        raise StandardError, 'sample_size should be positive' unless n.positive?
        raise StandardError, 'number_successes should be zero or more' unless r >= 0
      end

      def calculate!
        self.probability_of_success_lower_limit = g_binomial_dist.calc!.p
        self.probability_of_success_upper_limit = f_binomial_dist.calc!.p
        self.sample_error = (probability_of_success_upper_limit - probability_of_success_lower_limit) / 2
        self
      end

      # lower Gb( r/n, A) = alpha / 2
      def g_binomial_dist
        StatisticCalcs::Distributions::Binomial.new(g_x: alpha / 2, r: r - 1, n: n)
      end

      # upper Fb( r/n, B) = alpha / 2
      def f_binomial_dist
        StatisticCalcs::Distributions::Binomial.new(f_x: alpha / 2, r: r, n: n)
      end
    end
  end
end
