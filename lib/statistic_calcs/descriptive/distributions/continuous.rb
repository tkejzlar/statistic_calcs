# frozen_string_literal: true

require 'statistic_calcs/descriptive/distributions/base.rb'

module StatisticCalcs
  module Descriptive
    module Distributions
      class Continuous < Base
        def calc!
          self.f_x = gsl_f
          self.g_x = 1 - f_x
          super
        end

        def continuous?
          true
        end

        def discrete?
          false
        end
      end
    end
  end
end
