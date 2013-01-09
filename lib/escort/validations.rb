module Escort
  class Validations
    attr_reader :validation_setup, :validation_setup_accessor, :option_values, :parser

    def initialize(option_values, parser, &block)
      @option_values = option_values
      @parser = parser
      @validation_setup = Escort::Setup::Validation.new(&block)
      @validation_setup_accessor = Escort::Setup::Accessor::Validation.new(@validation_setup)
    end

    def validate
      validation_setup_accessor.validations.each_pair do |option, validations_array|
        ensure_option_being_validated_is_defined(option)
        validations_array.each do |validation_data|
          parser.die(option, validation_data[:message]) if option_value_fails_validation?(option, validation_data)
        end
      end
    end

    private

    def ensure_option_being_validated_is_defined(option)
      unless option_values.keys.include?(option)
        STDERR.puts "Unable to create validation for #{option} as no such option was defined, maybe you misspelled it"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end
    end

    def option_value_fails_validation?(option, validation_data)
      option_values[option] && !validation_data[:validation].call(option_values[option])
    end
  end
end
