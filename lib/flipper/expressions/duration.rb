require "flipper/expression"

module Flipper
  module Expressions
    class Duration < Expression
      SECONDS_PER = {
        "second" => 1,
        "minute" => 60,
        "hour" => 3600,
        "day" => 86400,
        "week" => 604_800,
        "month" => 26_29_746,  # 1/12 of a gregorian year
        "year" => 31_556_952 # length of a gregorian year (365.2425 days)
      }.freeze

      def initialize(args)
        scalar, unit = args
        super [scalar, unit || 'second']
      end

      def evaluate(context = {})
        scalar = evaluate_arg(0, context)
        unit = evaluate_arg(1, context) || 'second'
        unit = unit.to_s.downcase.chomp("s")

        unless scalar.is_a?(Numeric)
          raise ArgumentError.new("Duration value must be a number but was #{scalar.inspect}")
        end
        unless SECONDS_PER[unit]
          raise ArgumentError.new("Duration unit #{unit.inspect} must be one of: #{SECONDS_PER.keys.join(', ')}")
        end

        scalar * SECONDS_PER[unit]
      end
    end
  end
end