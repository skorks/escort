module Escort
  module Setup
    module Dsl
      class Global
        def initialize(&block)
          reset
          block.call(self)
        rescue => e
          raise Escort::ClientError.new("Problem with syntax of global configuration", e)
        end

        def options(&block)
          Options.options(:global, @options, &block)
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
        end

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

        def version(version)
          @version = version
        end

        def summary(summary)
          @summary = summary
        end

        def description(description)
          @description = description
        end

        def validations(&block)
          @validations = Validations.new(&block)
        end

        def conflict(*command_names)
          @conflicts << command_names
        end

        private

        def reset
          @version = nil
          @summary = nil
          @description = nil
          @commands = {}
          @requires_arguments = false
          @options = Options.new
          @action = Action.new(&null_action_block)
          @validations = Validations.new(&null_validations_block)
          @config_file  = nil
          @conflicts = []
        end

        def null_validations_block
          lambda{|x|}
        end

        def null_action_block
          lambda{|x,y,z|}
        end

        def set_instance_variable_on(instance, instance_variable, value)
          instance_variable_symbol = :"@#{instance_variable.to_s}"
          instance.instance_variable_set(instance_variable_symbol, value)
        end
      end
    end
  end
end
