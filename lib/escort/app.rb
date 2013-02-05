module Escort
  class App
    #TODO we can potentially catch the exceptional condition that if global action has already been defined, we can't define commands
    #TODO ensure that every command must have an action
    class << self
      def create(&block)
        setup = Escort::SetupAccessor.new(Escort::Setup::Dsl::Global.new(&block))
        app = self.new(setup)
        app.execute
        exit(0)
      end
    end

    attr_reader :setup

    def initialize(setup)
      @setup = setup
    end

    def execute
      #by default no config since no name for it
      #if configured then config gets created by default in home directory unless autocreate is false
      #config can be created in another directory by using command line option
      #default config can be created using an option for when autocreate was false
      #a particular config file can be used for an invocation

      cli_options = ARGV.dup
      configuration = {}
      #figure out which config file we need to use for this invocation, i.e. the default or one supplied by command line option
      #to figure out which file we need to pre-parse the global options and see if the config parameter was defined
      #if supplied by command line option we need to just load it and then parse everything again from scratch
      #if the default then try to load it and if it doesn't exit then create it and then load it

      #simplest
      #there is a file defined with autocreate then we need to find_or_create_and_load it
      if setup.has_config_file?
        if setup.config_file_autocreatable?
          configuration = Escort::Setup::Configuration.find_or_create_and_load(setup)
        else
          configuration = Escort::Setup::Configuration.find_and_load(setup)
        end
      end

      invoked_options, arguments = Escort::OptionParser.new(configuration, setup).parse(cli_options)
      context = context_from_options(invoked_options[:global])
      action = setup.action_for(context)
      user_config = configuration[:user] || {}
      action.call(invoked_options, Escort::Arguments.read(arguments, setup.arguments_required_for(context)), user_config)
    end

    private

    def context_from_options(options)
      commands_in_order(options)
    end

    def commands_in_order(options, commands = [])
      if options[:commands].keys.empty?
        commands
      else
        command = options[:commands].keys.first
        commands << command
        commands_in_order(options[:commands][command], commands)
      end
    end

    #def run_action(action)
    #end

    #attr_reader :global_setup, :options, :global_setup_accessor, :configuration

    #def initialize(global_setup)
      #@global_setup = global_setup
      #@global_setup_accessor = Escort::Setup::Accessor::Global.new(global_setup)
      #@configuration = Escort::Setup::Configuration.find_and_load(global_setup_accessor.default_config_file_name)
      #if @configuration.nil?
        ##create a default config file if autocreate is true
        ##default_config_file_data = {}
        #blah = Escort::Setup::DefaultConfigurationData.new(self, global_setup_accessor).generate
        #puts JSON.pretty_generate blah
        ##global_setup_accessor.command_aliases.each_pair do |command_name, aliases|
          ##current_command_setup = Escort::Setup::Command.new(global_setup)
          ##@global_setup = global_setup
          ##@global_setup_accessor = Escort::Setup::Accessor::Global.new(global_setup)
          ##@command_name = ensure_command_name
          ##@command_block = ensure_command_block(@command_name)
          ##@command_description = global_setup_accessor.command_descriptions[@command_name] || nil
          ##@command_block.call(self)
        ##end
        ##p current_command.parser.specs
        ##@configuration = Escort::Setup::Configuration.create_default(global_setup_accessor.default_config_file_name, config_file_values)
      #end
      ##if we have the configuration then don't need to create a config file even if autocreate is true
    #end

    #def has_sub_commands?
      #!global_setup_accessor.command_names.nil? && global_setup_accessor.command_names.size > 0
    #rescue => e
      #handle_error(e)
    #end

    #def execute_global_action
      #parse_global_setup_data
      #perform_action
    #rescue => e
      #handle_error(e)
    #end

    #def execute_active_command
      #parse_global_setup_data   # still need the global options and validations
      #current_command_setup = Escort::Setup::Command.new(global_setup_accessor)
      #command = Command.new(current_command_setup, self)
      #command.parse_options
      #command.merge_configuration_options_with_command_line_options(configuration)
      #command.parse_validations
      #command.perform_action
    #rescue => e
      #handle_error(e)
    #end

    #def parser
      #return @parser if @parser
      #@parser = Trollop::Parser.new(&global_setup_accessor.options_block)
      #@parser.stop_on(global_setup_accessor.command_names) #make sure we halt parsing if we see a command
      #@parser.version(global_setup_accessor.version)       #set the version if it was provided
      #@parser.help_formatter(Escort::Formatter::DefaultGlobal.new(global_setup_accessor))
      #add_config_file_options(@parser) if global_setup_accessor.config_file

      #@parser
    #end

    #private

    #def handle_error(e)
      #if e.kind_of? Escort::InternalError
        #raise e # we need to raise an Escort InternalError no matter what as it is a problem with Escort
      #else
        #e.extend(Escort::Error)
        #raise e
      #end
      #exit(Escort::INTERNAL_ERROR_EXIT_CODE) #execution finished unsuccessfully
    #end

    #def add_config_file_options(parser)
      #@parser.opt :config, "Path to the configuration file to use for this invocation", :short => :none, :long => 'config', :type => :string
      #@parser.opt :create_config, "Create configuration file using the specified path populated with default values for options", :short => :none, :long => 'create-config', :type => :string
      #@parser.opt :create_default_config, "Create configuration file using default name and location (i.e. #{ENV['HOME']}/#{global_setup_accessor.default_config_file_name}) populated with default values for options", :short => :none, :long => 'create-default-config', :type => :boolean, :default => false
    #end

    #def parse_global_setup_data
      #parse_options
      #merge_configuration_options_with_command_line_options(configuration)
      #parse_validations
    #end

    #def merge_configuration_options_with_command_line_options(configuration)
      #if configuration
        #global_options_from_configuration = configuration.global_options || {}
        #global_options_from_configuration.each_pair do |key, value|
          #next unless Escort::Utils.valid_config_key?(key)
          #is_given = :"#{key.to_s}_given"
          #options[key] = value if !options[is_given]
        #end
      #end
    #end

    #def parse_options
      #@options = Trollop::with_standard_exception_handling(parser) do
        #parser.parse(global_setup_accessor.options_string)
      #end
    #end

    #def parse_validations
      #Escort::Validations.new(options, parser, &global_setup_accessor.validations_block).validate if global_setup_accessor.validations_block
    #end

    #def perform_action
      #ensure_action_block
      #config = {}
      #config = configuration.user_data if global_setup_accessor.config_file
      #global_setup_accessor.action_block.call(options, Escort::Arguments.read(global_setup_accessor.arguments, global_setup_accessor.valid_with_no_arguments), config)
      ##raise "Can't define before blocks if there are no sub-commands" if @before_block
    #end

    #def ensure_action_block
      #unless global_setup_accessor.action_block
        #STDERR.puts "Must define a global action block if there are no sub-commands"
        #exit(Escort::CLIENT_ERROR_EXIT_CODE)
      #end
    #end

    ##def execute_before_block(command_name, global_options, command_options, arguments)
      ##@before_block.call(command_name, global_options, command_options, arguments) if @before_block
    ##end

    ##def execute_error_block(error)
      ##@error_block ? @error_block.call(error) : (raise error)
    ##end
  end
end
