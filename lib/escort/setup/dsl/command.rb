module Escort
  module Setup
    module Dsl
      class Command
        def initialize(name, options = {}, &block)
          reset
          @name = name
          @description = options[:desc] || ""
          @aliases = [options[:aliases] || []].flatten
          @requires_arguments ||= options[:requires_arguments]
          block.call(self) if block_given?
        rescue => e
          STDERR.puts "Problem with syntax of command '#{@name}' configuration"
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
        end

        def requires_arguments(boolean = true)
          #TODO raise a client error if the value is anything besides true or false
          @requires_arguments = boolean
          @commands.each do |command|
            command.requires_arguments(boolean)
          end
        end

        #def validations(&block)
          #@validations = Validations.new(@name, &block)
        #end

        private

        def reset
          @requires_arguments = false
          @commands = {}
          @options = Options.new(&null_options_block)
          @action = Action.new(&null_action_block)
          #@validations = nil
          @name = nil
          @description = nil
          @aliases = []
        end

        def null_options_block
          lambda{|x|}
        end

        def null_action_block
          lambda{|x,y|}
        end
      end
    end
  end
end
