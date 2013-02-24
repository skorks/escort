module Escort
  class Validator
    class << self
      def for(parser)
        self.new(parser)
      end
    end

    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def validate(options, validations)
      validations.each do |option, validations_array|
        if option_exists?(option)
          validate_option(option, options, validations_array)
        else
          Escort::Error.fatal_client_error("Unable to create validation for '#{option}' as no such option was defined, maybe you misspelled it")
          $stderr.puts "Unable to create validation for '#{option}' as no such option was defined, maybe you misspelled it"
          exit(Escort::CLIENT_ERROR_EXIT_CODE)
        end
      end
      options
    end

    private

    def option_exists?(option)
      parser.specs.keys.include?(option)
    end

    def validate_option(option, options, validations_array)
      validations_array.each do |validation_data|
        parser.die(option, validation_data[:desc]) if invalid?(option, options, validation_data)
      end
    end

    def invalid?(option, options, validation_data)
      options[option] && !validation_data[:block].call(options[option])
    end
  end
end
