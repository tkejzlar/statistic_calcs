# frozen_string_literal: true

module StatisticCalcs
  module Helpers
    class Array
      def depth
        map { |element| element.is_a?(Vector) ? element.depth + 1 : 1 }.max
      end
    end
  end
end
