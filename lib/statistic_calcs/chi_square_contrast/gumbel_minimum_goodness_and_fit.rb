# frozen_string_literal: true

require 'statistic_calcs/chi_square_contrast/goodness_and_fit'
require 'statistic_calcs/distributions/gumbel_minimum'
require 'statistic_calcs/helpers/math'

module StatisticCalcs
  module ChiSquareContrast
    class GumbelMinimumGoodnessAndFit < GumbelMaximumGoodnessAndFit
      # mean-Euler*thita
      def beta
        @beta ||= mean + Helpers::Math.euler * thita
      end

      private

      def f_gumbel_dist(x)
        StatisticCalcs::Distributions::GumbelMinimum.new(thita: thita, beta: beta, x: x).calc!.f_x
      end

      def g_gumbel_dist(x)
        StatisticCalcs::Distributions::GumbelMinimum.new(thita: thita, beta: beta, x: x).calc!.g_x
      end
    end
  end
end
