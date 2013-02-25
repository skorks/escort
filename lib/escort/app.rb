module Escort
  class App
    #TODO ensure that every command must have an action
    class << self
      def create(&block)
        cli_app_configuration = Escort::Setup::Dsl::Global.new(&block)
        setup = Escort::SetupAccessor.new(cli_app_configuration)
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
      begin
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
        actual_arguments = Escort::Arguments.read(arguments, setup.arguments_required_for(context))
      rescue => e
        handle_escort_error(e)
      end
      execute_action(action, invoked_options, actual_arguments, user_config)
    end

    private

    def execute_action(action, options, arguments, user_config)
      begin
        action.call(options, arguments, user_config)
      rescue => e
        handle_action_error(e)
      end
    end

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

    def handle_escort_error(e)
      if e.kind_of?(Escort::UserError)
        print_escort_error_message(e)
        exit(Escort::USER_ERROR_EXIT_CODE)
      elsif e.kind_of?(Escort::ClientError)
        print_escort_error_message(e)
        exit(Escort::CLIENT_ERROR_EXIT_CODE)
      else
        print_escort_error_message(e)
        exit(Escort::INTERNAL_ERROR_EXIT_CODE)
      end
    end

    def handle_action_error(e)
      if e.kind_of?(Escort::Error)
        print_escort_error_message(e)
        exit(Escort::INTERNAL_ERROR_EXIT_CODE)
      else
        print_stacktrace(e)
        exit(Escort::EXTERNAL_ERROR_EXIT_CODE)
      end
    end

    def print_stacktrace(e)
      $stderr.puts e.message
      $stderr.puts e.backtrace
    end

    def print_escort_error_message(e)
      print_stacktrace(e)
      $stderr.puts "\n\n"
      $stderr.puts "An internal Escort error has occurred, you should probably report it by creating an issue on github!"
    end
  end
end
