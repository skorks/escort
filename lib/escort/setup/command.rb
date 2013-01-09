module Escort
  module Setup
    class Command
      include Common

      attr_reader :global_setup_accessor

      def initialize(global_setup)
        reset
        @global_setup = global_setup
        @global_setup_accessor = GlobalSetupAccessor.new(global_setup)
        @command_name = global_setup_accessor.options_string.shift.to_s

        if @command_name.nil? || @command_name.strip.length == 0
          STDERR.puts "Expecting a command but none was provided"
          exit(3)  #it is a user error so exiting with error code 3
        end

        @command_block = global_setup_accessor.command_blocks[@command_name]
        unless @command_block
          STDERR.puts "Command '#{@command_name}' was found, but no such command is defined"
          exit(3)
        end

        @command_description = global_setup_accessor.command_descriptions[@command_name] || nil

        @command_block.call(self)
      rescue => e
        #TODO instead of printing to stderr do some logging e.g. Logger.error
        #this is a client usage of library error so returning with exit code 2
        #TODO we can perhaps create a method missing so that if we end up in there we know the syntax is screwed
        STDERR.puts "Problem with syntax of command '#{@command_name}' configuration"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end

      private

      def reset
        common_reset
      end

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
    end
  end
end
