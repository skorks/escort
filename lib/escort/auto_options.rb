module Escort
  class AutoOptions
    class << self
      def augment(setup)
        if setup.has_config_file?
          setup.add_global_option :config, "Configuration file to use for this execution", :short => :none, :long => '--config', :type => :string

          setup.add_global_command :escort, :description => "Auto created utility command", :aliases => [] do |command|
            command.requires_arguments false

            command.options do |opts|
              opts.opt :create_config, "Create configuration file at specified location", :short => :none, :long => '--create-config', :type => :string
              opts.opt :create_default_config, "Create a default configuration file", :short => :none, :long => '--create-default-config', :type => :boolean, :default => false
              opts.opt :update_config, "Update configuration file at specified location", :short => :none, :long => '--update-config', :type => :string
              opts.opt :update_default_config, "Update the default configuration file", :short => :none, :long => '--update-default-config', :type => :boolean, :default => false
            end

            command.conflicting_options :create_config, :create_default_config, :update_config, :update_default_config

            command.action do |options, arguments|
              ActionCommand::EscortUtilityCommand.new(setup, options, arguments).execute
            end
          end
        end
        setup.add_global_option :verbosity, "Verbosity level of output for current execution (e.g. INFO, DEBUG)", :short => :none, :long => '--verbosity', :type => :string, :default => "WARN"

        setup.add_global_option :error_output_format, "The format to use when outputting errors (e.g. basic, advanced)", :short => :none, :long => '--error-output-format', :type => :string, :default => "basic"
        #TODO validations for the output format and the verbosity
      end
    end

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def non_default_config_path
      if options[:config_given] && File.exists?(config_path)
        config_path
      elsif !options[:config_given]
        nil
      else
        error_logger.warn "The given config file '#{options[:config]}' does not exist, falling back to default"
        nil
      end
    end

    def verbosity
      error_verbosity.upcase
    end

    def error_formatter
      error_output_format.to_sym
    end

    private

    def config_path
      File.expand_path(options[:config])
    end

    def error_output_format
      options[:error_output_format]
    end

    def error_verbosity
      options[:verbosity]
    end
  end
end
