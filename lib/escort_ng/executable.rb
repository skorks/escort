module Escort
  class Executable
    attr_reader :option_string, :command_map, :option_registry

    def initialize(option_string, command_map, option_registry)
      @option_string = option_string
      @command_map = command_map
      @option_registry = option_registry
    end

    def run
      cli_params = CliParams.new(option_list)
      command_key = cli_params.parse_command(command_map)
      command_class = determine_command_class(command_key)
      valid_options = command_class.valid_options
      given_options = cli_params.parse_options(option_registry)
      #ensure that no invalid options were given



      #command_class_or_block = command_map.command_for(provided_command_key)
      #command_map.executable_for(cli_params.command, cli_params.options(option_registry), cli_params.arguments).execute
      #TODO introduce an exit call here when things are further along
    end

    private

    def determine_command_class(command_key)
      if command_map.has_command_for?(command_key)
        command_map.command_for(command_key)
      else
        BlockExecutionCommand
      end
    end

    def option_list
      passed_in_option_list = Escort::Utils.tokenize_option_string(option_string || '')
      passed_in_option_list.empty? ? ARGV.dup : passed_in_option_list
    end
  end
end
