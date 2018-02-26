# frozen_string_literal: true

require 'statistic_calcs/chi_square_contrast/goodness_and_fit'
require 'statistic_calcs/distributions/normal'

module StatisticCalcs
  module ChiSquareContrast
    class NormalGoodnessAndFit < GoodnessAndFit
      def init!
        super
        self.parameter_quantity = 2
      end

      def success_probability(index, _cluster)
        last = index == clusters_count - 1
        return g_normal_dist(lower_class_boundary_values[index]) if last
        fa = index.zero? ? 0 : f_normal_dist(lower_class_boundary_values[index])
        fb = f_normal_dist(upper_class_boundary_values[index])
        fb - fa
      end

      private

      def f_normal_dist(x)
        StatisticCalcs::Distributions::Normal.new(x: x, mean: mean, standard_deviation: standard_deviation).calc!.f_x
      end

      def g_normal_dist(x)
        StatisticCalcs::Distributions::Normal.new(x: x, mean: mean, standard_deviation: standard_deviation).calc!.g_x
      end
    end
  end
end
