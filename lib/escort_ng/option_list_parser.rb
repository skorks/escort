module Escort
  class OptionListParser
    attr_reader :option_list, :command_map, :option_registry

    def initialize(option_list, command_map, option_registry)
      @original_option_list = option_list.dup
      @option_list = option_list.dup
      @command_map = command_map
      @option_registry = option_registry
    end

    def given_command_class
      if command_map.has_command_for?(command_key)
        command_map.command_for(command_key)
      else
        #TODO maybe raise an error of some sort here
      end
    end

    def given_options
      parse_options
    end

    def given_arguments
      @parser.leftovers
    end

    private

    def command_key
      Escort::CommandMap::DEFAULT_KEY
    end

    def parse_options
      @given_options ||= Trollop::with_standard_exception_handling(parser) do
        parser.parse(option_list)
      end
    end

    def parser
      @parser ||= Trollop::Parser.new(option_registry) do |option_registry|
        option_registry.each do |key, value|
          opt key, value
        end
      end
    end
  end
end
