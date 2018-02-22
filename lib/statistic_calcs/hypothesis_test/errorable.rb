# frozen_string_literal: true

module StatisticCalcs
  module HypothesisTest
    module Errorable
      attr_accessor :alpha, :confidence_level, :beta, :test_power

      # Alpha usually is 0.05 so confidence level usually 0.95
      def init!
        set_alpha
        set_beta
      end

      def validate!
        raise StandardError, 'alpha should be between 0 and 1' unless alpha.between?(0, 1)
        raise StandardError, 'confidence_level should be between 0 and 1' unless confidence_level.between?(0, 1)
        raise StandardError, 'beta should be between 0 and 1' unless beta.between?(0, 1)
        raise StandardError, 'test_power should be between 0 and 1' unless test_power.between?(0, 1)
      end

      private

      def set_beta
        if test_power
          self.beta = 1 - test_power
        else
          self.beta ||= 0.05
          self.test_power = 1 - beta
        end
      end

      def set_alpha
        if confidence_level
          self.alpha = 1 - confidence_level
        else
          self.alpha ||= 0.05
          self.confidence_level = 1 - alpha
        end
      end
    end
  end
end
