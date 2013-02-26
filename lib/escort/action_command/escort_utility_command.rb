module Escort
  module ActionCommand
    class EscortUtilityCommand < Base
      attr_reader :setup

      def initialize(setup, options, arguments, config = {})
        super(options, arguments, config)
        @setup = setup
      end

      def execute
        current_command_options = command_options
        if current_command_options[:create_config_given]
          create_config(current_command_options[:create_config])
        elsif current_command_options[:create_default_config_given]
          create_default_config
        elsif current_command_options[:update_config_given]
          update_config(current_command_options[:update_config])
        elsif current_command_options[:update_default_config_given]
          update_default_config
        end
      end

      private

      def create_config(path)
        config_path = absolute_path(path)
        Escort::Setup::Configuration::Writer.new(config_path, Escort::Setup::Configuration::Generator.new(setup).default_data).write
      end

      def create_default_config
        Escort::Setup::Configuration::Writer.new(default_config_path, Escort::Setup::Configuration::Generator.new(setup).default_data).write
      end

      def update_config(path)
        config_path = absolute_path(path)
        Escort::Setup::Configuration::Writer.new(config_path, Escort::Setup::Configuration::Generator.new(setup).default_data).update
      end

      def update_default_config
        Escort::Setup::Configuration::Writer.new(default_config_path, Escort::Setup::Configuration::Generator.new(setup).default_data).update
      end

      def absolute_path(path)
        File.expand_path(path)
      end

      def default_config_path
        Escort::Setup::Configuration::Loader.new(setup, nil).default_config_path
      end
    end
  end
end
