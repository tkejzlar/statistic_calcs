# frozen_string_literal: true

require 'statistic_calcs/chi_square_contrast/goodness_and_fit'
require 'statistic_calcs/distributions/log_normal'

module StatisticCalcs
  module ChiSquareContrast
    class LogNormalGoodnessAndFit < GoodnessAndFit
      def init!
        super
        self.parameter_quantity = 2
      end

      def success_probability(index, _cluster)
        last = index == clusters_count - 1
        return g_log_normal_dist(lower_class_boundary_values[index]) if last
        fa = index.zero? ? 0 : f_log_normal_dist(lower_class_boundary_values[index])
        fb = f_log_normal_dist(upper_class_boundary_values[index])
        fb - fa
      end

      private

      def f_log_normal_dist(x)
        StatisticCalcs::Distributions::LogNormal.new(x: x, zeta: ln_mean, sigma: ln_standard_deviation).calc!.f_x
      end

      def g_log_normal_dist(x)
        StatisticCalcs::Distributions::LogNormal.new(x: x, zeta: ln_mean, sigma: ln_standard_deviation).calc!.g_x
      end

      # mu = log((m^2)/sqrt(v+m^2));
      def ln_mean
        Math.log(mean**2 / (variance + mean**2)**0.5)
      end

      # sigma = sqrt(log((v/m^2)+1));
      def ln_standard_deviation
        Math.log(1 + (variance / mean**2))**0.5
      end
    end
  end
end
