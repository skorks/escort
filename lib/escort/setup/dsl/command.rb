module Escort
  module Setup
    module Dsl
      class Command
        def initialize(name, options = {}, &block)
          reset(name)
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

        def action(command_class = nil, &block)
          Action.action(@name, @action, command_class, &block)
        end

        def command(name, options = {}, &block)
          options[:requires_arguments] = @requires_arguments
          command = Command.new(name.to_sym, options, &block)
          aliases = [options[:aliases] || []].flatten + [name]
          aliases.each do |current_alias|
            @commands[current_alias.to_sym] = command
          end
        end

        def requires_arguments(boolean = true)
          raise Escort::ClientError.new("Parameter to 'requires_arguments' must be a boolean") unless [true, false].include?(boolean)
          @requires_arguments = boolean
          @commands.each do |command|
            command.requires_arguments(boolean)
          end
        end

        def summary(summary)
          @summary = summary
        end

        def description(description)
          @description = description
        end

        private

        def reset(name)
          @name = name
          @summary = nil
          @description = nil
          @requires_arguments = false
          @commands = {}
          @options = Options.new(name)
          @action = Action.new(name)
          custom_reset
        end

        def custom_reset
          @aliases = []
        end
      end
    end
  end
end
