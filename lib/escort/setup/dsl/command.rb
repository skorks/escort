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

        def validations(&block)
          @validations = Validations.new(&block)
        end

        def conflict(*command_names)
          @conflicts << command_names
        end

        private

        def reset(name)
          @requires_arguments = false
          @commands = {}
          @options = Options.new(name)
          @action = Action.new(&null_action_block)
          @validations = Validations.new(&null_validations_block)
          @name = nil
          @description = nil
          @aliases = []
          @conflicts = []
        end

        def null_validations_block
          lambda{|x|}
        end

        def null_action_block
          lambda{|x,y,z|}
        end
      end
    end
  end
end
