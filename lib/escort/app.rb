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
      #TODO user and client errors should be outputted with error messages about what the problem is (and then exit with approprate exit code)
      #TODO if the verbosity level is high enough it should still dump the stack trace
      #TODO other types of escort errors are internal fatal errors and should be treated as such (print the stack trace and exit with the right exit code)
      p "HELO"
      raise e
      #TODO what kind of errors can we rescue here
      #perhaps we don't exit or output anything anywhere in the app except here, just need to create error objects with enough info to do it here
      #if e.kind_of? Escort::InternalError
        ##TODO rather than raising an error here, we need to print out the message and backtrace
        #raise e                                 # we need to raise an Escort InternalError no matter what as it is a problem with Escort
      #else
        #e.extend(Escort::Error)
        #raise e
      #end
      #exit(Escort::INTERNAL_ERROR_EXIT_CODE)
    end

    def handle_action_error(e)
      #TODO if an escort error type comes through here then handle it as an escort fatal error type (print the stack trace and exit with the right exit code)
      #TODO also for escort errors print a message that it is an escort error and it is perhaps a bug with escort and what to do about it
      #TODO otherwise print the stack trace and exit with a different exit code
      raise e
    end
  end
end
