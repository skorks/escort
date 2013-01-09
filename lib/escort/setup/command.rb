module Escort
  module Setup
    class Command
      include Common

      attr_reader :global_setup_accessor

      def initialize(global_setup)
        reset
        @global_setup = global_setup
        @global_setup_accessor = Escort::Setup::Accessor::Global.new(global_setup)
        @command_name = ensure_command_name
        @command_block = ensure_command_block(@command_name)
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

      def ensure_command_name
        command_name = global_setup_accessor.options_string.shift.to_s
        if command_name.nil? || command_name.strip.length == 0
          STDERR.puts "Expecting a command but none was provided"
          exit(Escort::USER_ERROR_EXIT_CODE)  #it is a user error so exiting with error code 3
        end
        command_name
      end

      def ensure_command_block(command_name)
        command_block = global_setup_accessor.command_blocks[command_name]
        unless command_block
          STDERR.puts "Command '#{command_name}' was found, but no such command is defined"
          exit(Escort::USER_ERROR_EXIT_CODE)  #it is a user error so exiting with error code 3
        end
        command_block
      end
    end
  end
end
