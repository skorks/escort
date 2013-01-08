module Escort
  class Validations
    class << self
      def validate(option_values, parser, &block)
        validations_instance = self.new
        block.call(validations_instance)
        validations_instance.validations.each_pair do |option, validations_array|
          raise "Unable to create validation for #{option} as no such option was defined, maybe you misspelled it" unless option_values.keys.include?(option)
          validations_array.each do |validation_data|
            if option_values[option] && !validation_data[:validation].call(option_values[option])
              parser.die(option, validation_data[:message])
            end
          end
        end
      end
    end

    attr_reader :validations

    def initialize
      @validations = {}
    end

    def validate(option_symbol, error_message, &validation_block)
      @validations[option_symbol] ||= []
      @validations[option_symbol] << {:message => error_message, :validation => validation_block}
    end
  end
end
