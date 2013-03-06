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

        def command(name, options = {}, &block)
          options[:requires_arguments] = @requires_arguments
          command = Command.new(name.to_sym, options, &block)
          aliases = [options[:aliases] || []].flatten + [name]
          aliases.each do |name|
            @commands[name.to_sym] = command
          end
        end

        def requires_arguments(boolean = true)
          raise Escort::ClientError.new("Parameter to 'requires_arguments' must be a boolean") unless [true, false].include?(boolean)
          @requires_arguments = boolean
          @commands.each do |command|
            command.requires_arguments(boolean)
          end
        end

        def conflicting_options(*command_names)
          raise Escort::ClientError.new("This interface for specifying conflicting options is no longer supported, please use 'opts.conflict' in the options block")
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
          @name = nil
          @description = nil
          @aliases = []
          @summary = nil
        end
      end
    end
  end
end
