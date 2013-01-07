module Escort
  class ValidatioOptions
    attr_reader :validations

    def initialize
      @validations = {}
    end

    def validate(option_symbol, error_message, &validation_block)
      @validations[option_symbol] = {:message => error_message, :validation => validation_block}
    end
  end
end
