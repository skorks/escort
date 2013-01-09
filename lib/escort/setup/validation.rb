module Escort
  module Setup
    class Validation
      def initialize(&block)
        @validations = {}
        block.call(self)
      end

      def validate(option_symbol, error_message, &validation_block)
        @validations[option_symbol] ||= []
        @validations[option_symbol] << {:message => error_message, :validation => validation_block}
      end
    end
  end
end
