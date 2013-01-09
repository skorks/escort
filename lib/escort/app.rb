module Escort
  class App
    class << self
      def create(options_string = nil, &block)
        app = self.new(Escort::Setup::Global.new(options_string, &block))
        app.has_sub_commands? ? app.execute_active_command : app.execute_global_action
        exit(0)
      end
    end

    attr_reader :global_setup, :options, :global_setup_accessor

    def initialize(global_setup)
      @global_setup = global_setup
      @global_setup_accessor = GlobalSetupAccessor.new(global_setup)
    end

    def has_sub_commands?
      !global_setup_accessor.command_names.nil? && global_setup_accessor.command_names.size > 0
    rescue => e
      handle_error(e)
    end

    def execute_global_action
      parse_options
      perform_action
    rescue => e
      handle_error(e)
    end

    def execute_active_command
      parse_options   # we still need to parse the global options
      current_command_setup = Escort::Setup::Command.new(global_setup)
      command = Command.new(current_command_setup, self)
      command.parse_options
      command.perform_action
    rescue => e
      handle_error(e)
    end

    private

    def handle_error(e)
      e.extend(Escort::Error)
      raise e
      exit(1) #execution finished unsuccessfully
    end

    def parse_options
      @parser = Trollop::Parser.new(&global_setup_accessor.options_block)
      @parser.stop_on(global_setup_accessor.command_names)

      @options = Trollop::with_standard_exception_handling(@parser) do
        @parser.parse(global_setup_accessor.options_string)
      end
      #Escort::Validations.validate(@current_options, parser, &@validations_block) if @validations_block
    end

    def perform_action
      #TODO should this even raise, or should it just print an error to stderr and jump to an exit block
      raise Escort::ClientError, "Must define a global action block if there are no sub-commands" unless global_setup_accessor.action_block
      global_setup_accessor.action_block.call(options, Escort::Arguments.read(global_setup_accessor.arguments))
      #if command_names.nil? || command_names.size == 0
        ##TODO what should be raised here (ClientError), should anything
        #raise "Must define a global action block if there are no sub-commands" unless @action_block
        #raise "Can't define before blocks if there are no sub-commands" if @before_block
        #@action_block.call(current_options, Escort::Arguments.read(arguments, @no_arguments_valid))
      #else
        ##TODO what should be raised here (ClientError), should anything
        #raise "Can't define global actions for an app with sub-commands"
      #end
    end









    #def arguments
      #@options_string
    #end

    #def valid_with_no_arguments
      #@no_arguments_valid
    #end

    #def parse_options
      #parser = Trollop::Parser.new(&@options_block)
      #parser.stop_on(@command_names)

      #@current_options = Trollop::with_standard_exception_handling(parser) do
        #parser.parse @options_string
      #end
      #Escort::Validations.validate(@current_options, parser, &@validations_block) if @validations_block
    #end

    #def current_command
      #return @current_command if @current_command
      #command_name = @options_string.shift.to_s
      #command_block = @command_blocks[command_name]
      #command_description = @command_descriptions[command_name] || nil
      ##TODO what should be raised here (UserError), should anything
      #raise "No command was passed in" unless command_block
      #@current_command = Command.new(command_name, command_description, @options_string)
      #command_block.call(@current_command)
      #@current_command
    #end

    #def execute_before_block(command_name, global_options, command_options, arguments)
      #@before_block.call(command_name, global_options, command_options, arguments) if @before_block
    #end

    #def perform_action(current_options, arguments)
      #if command_names.nil? || command_names.size == 0
        ##TODO what should be raised here (ClientError), should anything
        #raise "Must define a global action block if there are no sub-commands" unless @action_block
        #raise "Can't define before blocks if there are no sub-commands" if @before_block
        #@action_block.call(current_options, Escort::Arguments.read(arguments, @no_arguments_valid))
      #else
        ##TODO what should be raised here (ClientError), should anything
        #raise "Can't define global actions for an app with sub-commands"
      #end
    #end

    #def execute_error_block(error)
      ##TODO make sure we tag the error here if we're going to re-raise it
      #@error_block ? @error_block.call(error) : (raise error)
    #end
  end
end
