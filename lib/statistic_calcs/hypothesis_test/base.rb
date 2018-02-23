# frozen_string_literal: true

require 'statistic_calcs/helpers/alias_attributes.rb'
require 'statistic_calcs/hypothesis_test/errorable.rb'

require 'pry'

module StatisticCalcs
  module HypothesisTest
    # 1 - alpha = Prob(no reject true h0). Correct decision
    # alpha = Prob(reject true h0). Type 1 error. worst error
    # 1 - beta = Prob(reject false h0). Type 2 less serious error
    # beta = Prob(no reject false h0). Correct decision
    class Base
      include StatisticCalcs::Helpers::AliasAttributes
      include StatisticCalcs::HypothesisTest::Errorable

      attr_accessor :null_hypothesis, :alternative_hypothesis, :population_size,
                    :case, :result, :reject_condition, :reject, :sample_size,
                    :critical_fractil, :lower_critical_fractil, :upper_critical_fractil

      attr_alias :h0, :null_hypothesis
      attr_alias :h1, :alternative_hypothesis
      attr_alias :w, :test_power
      attr_alias :n, :sample_size

      def calc!
        init!
        validate!
        self
      end

      def degrees_of_freedom
        sample_size - 1
      end

      def case1?
        self.case == Cases::CASE_1
      end

      def case2?
        self.case == Cases::CASE_2
      end

      def case3?
        self.case == Cases::CASE_3
      end
    end
  end
end
