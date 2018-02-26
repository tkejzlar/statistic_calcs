# frozen_string_literal: true

require 'statistic_calcs/chi_square_contrast/goodness_and_fit'
require 'statistic_calcs/distributions/gumbel_maximum'
require 'statistic_calcs/helpers/math'

module StatisticCalcs
  module ChiSquareContrast
    class GumbelMaximumGoodnessAndFit < GoodnessAndFit
      def init!
        super
        self.parameter_quantity = 2
      end

      def success_probability(index, _cluster)
        last = index == clusters_count - 1
        a = lower_class_boundary_values[index]
        b = upper_class_boundary_values[index]
        return g_gumbel_dist(a) if last
        fa = index.zero? ? 0 : f_gumbel_dist(a)
        fb = f_gumbel_dist(b)
        (fb - fa).abs
      end

      # SQRT(6)*ds/PI()
      def thita
        @thita ||= 6**0.5 * standard_deviation / Helpers::Math.pi
      end

      # mean-Euler*thita
      def beta
        @beta ||= mean - Helpers::Math.euler * thita
      end

      private

      def f_gumbel_dist(x)
        StatisticCalcs::Distributions::GumbelMaximum.new(thita: thita, beta: beta, x: x).calc!.f_x
      end

      def g_gumbel_dist(x)
        StatisticCalcs::Distributions::GumbelMaximum.new(thita: thita, beta: beta, x: x).calc!.g_x
      end
    end
  end
end
