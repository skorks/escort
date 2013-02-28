module Escort
  module Setup
    module Dsl
      class Command
        def initialize(name, options = {}, &block)
          reset(name)
          @name = name
          @description = options[:description] || options[:desc] || ""
          @aliases = [options[:aliases] || []].flatten
          @requires_arguments ||= options[:requires_arguments]
          block.call(self) if block_given?
        rescue => e
          raise Escort::ClientError.new("Problem with syntax of command '#{@name}' configuration", e)
        end

        def options(&block)
          Options.options(@name, @options, &block)
        end

        def action(&block)
          Action.action(@name, @action, &block)
        end

        def validations(&block)
          Validations.validations(@name, @validations, &block)
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

        def conflicting_options(*command_names)
          @conflicts << command_names
        end

        def summary(summary)
          @summary = summary
        end

        def description(description)
          @description = description
        end

        private

        def reset(name)
          @requires_arguments = false
          @commands = {}
          @options = Options.new(name)
          @action = Action.new(name)
          @validations = Validations.new(name)
          @name = nil
          @description = nil
          @aliases = []
          @conflicts = []
          @summary = nil
        end
      end
    end
  end
end
