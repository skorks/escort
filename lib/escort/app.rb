module Escort
  class App
    class << self
      def create(options_string = nil, &block)
        app = self.new(Escort::Setup::Global.new(options_string, &block))
        app.has_sub_commands? ? app.execute_active_command : app.execute_global_action
        exit(0)
      end
    end

    attr_reader :global_setup, :options, :global_setup_accessor, :parser

    def initialize(global_setup)
      @global_setup = global_setup
      @global_setup_accessor = Escort::Setup::Accessor::Global.new(global_setup)
    end

    def has_sub_commands?
      !global_setup_accessor.command_names.nil? && global_setup_accessor.command_names.size > 0
    rescue => e
      handle_error(e)
    end

    def execute_global_action
      parse_global_setup_data
      perform_action
    rescue => e
      handle_error(e)
    end

    def execute_active_command
      parse_global_setup_data   # still need the global options and validations
      current_command_setup = Escort::Setup::Command.new(global_setup)
      command = Command.new(current_command_setup, self)
      command.parse_options
      command.parse_validations
      command.perform_action
    rescue => e
      handle_error(e)
    end

    private

    def handle_error(e)
      e.extend(Escort::Error)
      raise e
      exit(Escort::INTERNAL_ERROR_EXIT_CODE) #execution finished unsuccessfully
    end

    def parse_global_setup_data
      parse_options
      parse_validations
    end

    def parse_options
      @parser = Trollop::Parser.new(&global_setup_accessor.options_block)
      @parser.stop_on(global_setup_accessor.command_names) #make sure we halt parsing if we see a command

      @options = Trollop::with_standard_exception_handling(@parser) do
        @parser.parse(global_setup_accessor.options_string)
      end
    end

    def parse_validations
      Escort::Validations.new(options, parser, &global_setup_accessor.validations_block).validate if global_setup_accessor.validations_block
    end

    def perform_action
      ensure_action_block
      global_setup_accessor.action_block.call(options, Escort::Arguments.read(global_setup_accessor.arguments, global_setup_accessor.valid_with_no_arguments))
      #raise "Can't define before blocks if there are no sub-commands" if @before_block
    end

    def ensure_action_block
      unless global_setup_accessor.action_block
        STDERR.puts "Must define a global action block if there are no sub-commands"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end
    end









    #def valid_with_no_arguments
      #@no_arguments_valid
    #end

    #def execute_before_block(command_name, global_options, command_options, arguments)
      #@before_block.call(command_name, global_options, command_options, arguments) if @before_block
    #end

    #def execute_error_block(error)
      ##TODO make sure we tag the error here if we're going to re-raise it
      #@error_block ? @error_block.call(error) : (raise error)
    #end
  end
end
