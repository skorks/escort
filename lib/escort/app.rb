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
        #by default no config since no name for it DONE
        #if configured then config gets created by default in home directory unless autocreate is false DONE
        #a particular config file can be used for an invocation DONE

        #config can be created in another directory by using command line option xxx escort --create-config='./blah.txt' DONE
        #default config can be created using an option for when autocreate was false xxx escort --create-default-config DONE
        #any config can be updated (merge what you have with what is there) xxx escort --update-config='./blah.txt'
        #update default config xxx escort --update-default-config
        #the auto options should not be added magically within the dsl but through a separate action DONE

        AutoOptions.augment(setup)

        cli_options = ARGV.dup
        auto_options = Escort::GlobalPreParser.new(setup).parse(cli_options.dup)
        configuration = Escort::Setup::Configuration::Loader.new(setup, auto_options).configuration

        invoked_options, arguments = Escort::OptionParser.new(configuration, setup).parse(cli_options)
        context = context_from_options(invoked_options[:global])
        action = setup.action_for(context)
        actual_arguments = Escort::Arguments.read(arguments, setup.arguments_required_for(context))
      rescue => e
        handle_escort_error(e)
      end
      execute_action(action, invoked_options, actual_arguments, configuration.user)
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
