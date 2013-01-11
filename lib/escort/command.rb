module Escort
  class Command
    attr_reader :command_setup, :command_setup_accessor, :app, :options

    def initialize(command_setup, app)
      @command_setup = command_setup
      @command_setup_accessor = Escort::Setup::Accessor::Command.new(command_setup)
      @app = app
    end

    def merge_config_options_into_parser
      #TODO merge the global config stuff into parser before parsing options that way config options get overriden by command line and get validated
      raise "need to merge config options into parser here for command"
    end

    def parse_options
      @options = Trollop::with_standard_exception_handling(parser) do
        parser.parse(app.global_setup_accessor.options_string)
      end
    end

    def merge_configuration_options_with_command_line_options(configuration)
      if configuration
        options_from_configuration = configuration.command_options[command_setup_accessor.command_name.to_sym] || {}
        options_from_configuration.each_pair do |key, value|
          next unless Escort::Utils.valid_config_key?(key)
          is_given = :"#{key.to_s}_given"
          options[key] = value if !options[is_given]
        end
      end
    end

    def parse_validations
      Escort::Validations.new(options, parser, &command_setup_accessor.validations_block).validate if command_setup_accessor.validations_block
    end

    def perform_action
      ensure_no_global_action_block
      ensure_action_block_for_command
      config = {}
      config = app.configuration.user_data if app.global_setup_accessor.config_file
      command_setup_accessor.action_block.call(app.options, options, Escort::Arguments.read(command_setup.global_setup_accessor.arguments, command_setup.global_setup_accessor.valid_with_no_arguments), config)
    end

    def parser
      return @parser if @parser
      @parser = Trollop::Parser.new(&command_setup_accessor.options_block)
      @parser.help_formatter(Escort::Formatter::DefaultCommand.new(command_setup_accessor, app.global_setup_accessor))
      @parser
    end

    private

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
