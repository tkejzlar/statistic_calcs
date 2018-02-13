# frozen_string_literal: true

module StatisticCalcs
  module Inference
    module Errorable
      attr_accessor :alpha, :confidence_level

      private

      # Alpha usually is 0.05 so confidence level usually 0.95
      def init!
        if confidence_level
          self.alpha = 1 - confidence_level
        else
          self.alpha ||= 0.05
          self.confidence_level = 1 - alpha
        end
      end

      def validate!
        raise StandardError, 'alpha should be between 0 and 1' unless alpha.between?(0, 1)
        raise StandardError, 'confidence_level should be between 0 and 1' unless confidence_level.between?(0, 1)
      end
    end
  end
end
