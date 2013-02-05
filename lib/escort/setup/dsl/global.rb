module Escort
  module Setup
    module Dsl
      class Global
        def initialize(&block)
          reset
          block.call(self)
        rescue => e
          STDERR.puts "Problem with syntax of app global configuration"
          #TODO need some way to enable more verbose error output
          #TODO remove this
          STDERR.puts e
          STDERR.puts e.backtrace
          exit(Escort::CLIENT_ERROR_EXIT_CODE)
        end

        def options(&block)
          @options = Options.new(&block)
        end

        def action(&block)
          @action = Action.new(&block)
        end

        def command(name, options = {}, &block)
          options[:requires_arguments] = @requires_arguments
          command = Command.new(name.to_sym, options, &block)
          aliases = [options[:aliases] || []].flatten + [name]
          aliases.each do |name|
            @commands[name.to_sym] = command
          end
          #p @commands
        end

        #def validations(&block)
          #@validations = Validations.new(&block)
        #end

        def requires_arguments(boolean = true)
          #TODO raise a client error if the value is anything besides true or false
          @requires_arguments = boolean
          @commands.each do |command|
            command.requires_arguments(boolean)
          end
        end

        def config_file(name, options = {})
          @config_file = ConfigFile.new(name, options)
        end

        private

        def reset
          @commands = {}
          @requires_arguments = false
          @options = Options.new(&null_options_block)
          @action = Action.new(&null_action_block)
          @config_file  = nil
          #@validations = nil
        end

        def null_options_block
          lambda{|x|}
        end

        def null_action_block
          lambda{|x,y|}
        end

        def set_instance_variable_on(instance, instance_variable, value)
          instance_variable_symbol = :"@#{instance_variable.to_s}"
          instance.instance_variable_set(instance_variable_symbol, value)
        end
      end
    end
  end
end
