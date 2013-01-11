module Escort
  module Setup
    class DefaultConfigurationData

      attr_reader :global_setup_accessor, :app

      def initialize(app, global_setup_accessor)
        @global_setup_accessor = global_setup_accessor
        @app = app
      end

      def generate
        data = {}
        data[:global_options] = default_global_option_values
        if has_sub_commands?
          data[:command_options] = default_option_values_for_commands
        end
        data[:user_options] = {}
        data
      end

      private
      def has_sub_commands?
        !global_setup_accessor.command_names.nil? && global_setup_accessor.command_names.size > 0
      end

      def default_global_option_values
        hash = {}
        app.parser.specs.each_pair do |key, data|
          hash[key] = data[:default] || nil
        end
        hash
      end

      def default_option_values_for_commands
        hash = {}
        global_setup_accessor.command_aliases.each_pair do |command_name, aliases|
          hash[command_name.to_sym] = default_command_option_values(command_name)
        end
        hash
      end

      def default_command_option_values(command_name)
        hash = {}
        command_block = ensure_command_block(@command_name)
        command_setup = BareCommand.new
        command_block.call(command_setup)
        hash
      rescue => e
        STDERR.puts "Problem with syntax of command '#{command_name}' configuration"
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      end

      def ensure_command_block(command_name)
        command_block = global_setup_accessor.command_blocks[command_name]
        unless command_block
          STDERR.puts "No configuration found for command '#{command_name}'"
          exit(Escort::CLIENT_ERROR_EXIT_CODE)
        end
        command_block
      end

      def command_options_for(&block)
        Trollop::Parser.new(&block)
      end
    end
  end
end
