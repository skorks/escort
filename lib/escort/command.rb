module Escort
  class Command
    attr_reader :command_setup, :command_setup_accessor, :app, :options

    def initialize(command_setup, app)
      @command_setup = command_setup
      @command_setup_accessor = Escort::Setup::Accessor::Command.new(command_setup)
      @app = app
    end

    def parse_options
      @options = Trollop::with_standard_exception_handling(parser) do
        parser.parse(app.global_setup_accessor.options_string)
      end
    end

    def parse_validations
      Escort::Validations.new(options, parser, &command_setup_accessor.validations_block).validate if command_setup_accessor.validations_block
    end

    def perform_action
      ensure_no_global_action_block
      ensure_action_block_for_command
      command_setup_accessor.action_block.call(app.options, options, Escort::Arguments.read(command_setup.global_setup_accessor.arguments, command_setup.global_setup_accessor.valid_with_no_arguments))
    end

    private
    def parser
      return @parser if @parser
      @parser = Trollop::Parser.new(&command_setup_accessor.options_block)
      @parser.help_formatter(Escort::Formatter::DefaultCommand.new(command_setup_accessor, app.global_setup_accessor))
      @parser
    end

    def ensure_action_block_for_command
      unless command_setup_accessor.action_block
        STDERR.puts "Must define an action block for command '#{command_setup_accessor.command_name}'"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end
    end

    def ensure_no_global_action_block
      if command_setup.global_setup_accessor.action_block
        STDERR.puts "Can't define a global action block for app with sub-commands"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end
    end
  end
end
