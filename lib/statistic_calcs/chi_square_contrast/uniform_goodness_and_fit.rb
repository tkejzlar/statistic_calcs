# frozen_string_literal: true

require 'statistic_calcs/chi_square_contrast/goodness_and_fit'

module StatisticCalcs
  module ChiSquareContrast
    class UniformGoodnessAndFit < GoodnessAndFit
      def init!
        super
        self.parameter_quantity = 0
        self.expected_frequencies = Array.new(clusters_count, sample_size / clusters_count)
      end

      def success_probability(_index, _cluster)
        1.0 / clusters_count
      end
    end
  end
end
