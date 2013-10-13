module Escort
  class Executable
    attr_reader :option_string, :command_map, :option_registry

    def initialize(option_string, command_map, option_registry)
      @option_string = option_string
      @command_map = command_map
      @option_registry = option_registry
    end

    def run
      option_list_parser = OptionListParser.new(option_list, command_map, option_registry)
      command_class = option_list_parser.given_command_class

      execute_command(command_class, option_list_parser.given_options, option_list_parser.given_arguments)
      #TODO introduce an exit call here when things are further along
    end

    private

    def execute_command(command_class, options, arguments)
      if command_class.kind_of?(Proc)
        BlockExecutionCommand.new(options, arguments, &command_class).execute
      else
        command_class.new(options, arguments).execute
      end
    end

    def option_list
      passed_in_option_list = Escort::Utils.tokenize_option_string(option_string || '')
      passed_in_option_list.empty? ? ARGV.dup : passed_in_option_list
    end
  end
end
